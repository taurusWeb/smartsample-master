//
//  searchViewController.m
//  smartSample
//
//  Created by Leela Electronics on 23/12/15.
//  Copyright (c) 2015 Leela Electronics. All rights reserved.
//

#import "searchViewController.h"
#import "searchSubjectTableViewCell.h"
#import "commonClass.h"

#define RGB(r,g,b,a)		[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define COMMON_RADIUS       10

@interface searchViewController ()<TLTagsControlDelegate>
{
    NSIndexSet * indexes;
    BOOL positionValue;
}
@end

@implementation searchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    positionValue = NO;
    
    indexes = [NSIndexSet indexSet];
    self.tagsView.tagsBackgroundColor = [UIColor colorWithRed:(103.0f/255.0f) green:(205.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0];
    self.tagsView.tagsDeleteButtonColor = [UIColor whiteColor];
    self.tagsView.tagsTextColor = [UIColor whiteColor];
    self.tagsView.mode = TLTagsControlModeEdit;
    self.tagsView.tapDelegate = self;
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"subjects"]count])
    {
        [self.tagsView addTags:[[[NSUserDefaults standardUserDefaults]objectForKey:@"subjects"] valueForKey:@"topic_title"]];
        self.tagsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"subjects"]];
        positionValue = YES;
    }
    else
    {
         self.tagsArray = [[NSMutableArray alloc]init];
    }
    [self.tagsView reloadTagSubviews];
    
    
   
    self.searchImageView.layer.cornerRadius = COMMON_RADIUS;
    self.searchImageView.layer.borderColor = RGB(107, 191, 228, 1).CGColor;
    self.searchImageView.layer.borderWidth = 1.5f;
    
    // Button Shape
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.searchDoneButton.bounds
                                                   byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight)
                                                         cornerRadii:CGSizeMake(COMMON_RADIUS, COMMON_RADIUS)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.searchDoneButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.searchDoneButton.layer.mask = maskLayer;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
    {
            
        NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/topic/get"];
        
         self.dataArray = [commonClass get:urlString];
       
        if([self.dataArray count])
        {
            self.dataShowArray = [NSMutableArray arrayWithArray:self.dataArray];
        }
        else
        {
            self.dataShowArray = [[NSMutableArray alloc]init];
        }

    });
    

    self.searchTableView.hidden = YES;
    self.emptyTableImageView.hidden = NO;
    
}

- (void)viewDidLayoutSubviews
{
    if((positionValue) && ( self.tagsView.contentSize.width > self.tagsView.bounds.size.width))
    {
        CGPoint bottomOffset = CGPointMake(self.tagsView.contentSize.width - self.tagsView.bounds.size.width,0);
        [self.tagsView setContentOffset:bottomOffset animated:YES];
        positionValue = NO;
    }
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TLTagControl DelegateMethods

- (void)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacedString:(NSString *)string
{
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(searchStr.length > 0)
    {
        if([self.dataArray count])
        {
            NSMutableArray * filterArray = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < [[self.dataArray valueForKey:@"topic_title"]count]; i++)
            {
                if ([[self.dataArray valueForKey:@"topic_title"][i] rangeOfString:searchStr options:NSCaseInsensitiveSearch].location != NSNotFound)
                {
                    [filterArray addObject:self.dataArray[i]];
                }
            }
            
            self.dataShowArray = [filterArray mutableCopy];
            
        }
        
        if([self.dataShowArray count] && [self.searchTableView isHidden])
        {
            self.searchTableView.hidden = NO;
            self.emptyTableImageView.hidden = YES;
        }
    }
    else
    {
        if(![self.searchTableView isHidden])
        {
            self.searchTableView.hidden = YES;
            self.emptyTableImageView.hidden = NO;
        }
        
        if([self.dataArray count])
        {
            self.dataShowArray = [NSMutableArray arrayWithArray:self.dataArray];
        }
    }
    
    [self.searchTableView reloadData];
    
}

- (void)removedTag:(NSString *)string
{
    
    for (int i = 0; i < [self.tagsArray count]; i++)
    {
        if([[self.tagsArray valueForKey:@"topic_title"] [i] isEqualToString:string])
        {
            [self.tagsArray removeObjectAtIndex:i];
        }
    }
    
    [self.searchTableView reloadData];
}


#pragma mark - UITableView DelegateMethods

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.dataShowArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    searchSubjectTableViewCell * cell = (searchSubjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"subjectCell"];
    if(cell == nil)
    {
        cell = [[searchSubjectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subjectCell"];
        
    }
    
    cell.titleLabel.text = [self.dataShowArray valueForKey:@"topic_title"][indexPath.row];
    
    BOOL containValue = NO;
    
    for (int i = 0; i<[self.tagsArray count] ; i ++)
    {
        if([[self.tagsArray valueForKey:@"topic_title"][i] isEqualToString:[self.dataShowArray valueForKey:@"topic_title"][indexPath.row]])
        {
            containValue = YES;
        }
    }
    if(containValue)
    {
        cell.titleLabel.alpha = 0.5;
        cell.statusImageView.hidden = YES;
        cell.statusSelectedImageView.hidden = NO;
    }
    else
    {
        cell.titleLabel.alpha = 1;
        cell.statusImageView.hidden = NO;
        cell.statusSelectedImageView.hidden = YES;
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    searchSubjectTableViewCell * cell = (searchSubjectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  
    BOOL containsValue = NO;
    
    for (int i = 0; i < [self.tagsArray count]; i++)
    {
        if([[self.tagsArray valueForKey:@"topic_title"][i] isEqualToString:cell.titleLabel.text])
        {
            containsValue = YES;
            [self.tagsArray removeObjectAtIndex:i];
        }
    }
    if(containsValue)
    {
        cell.titleLabel.alpha = 1;
        cell.statusImageView.hidden = NO;
        cell.statusSelectedImageView.hidden = YES;

        [self.tagsView deleteTag:cell.titleLabel.text];
    }
    else
    {
        cell.titleLabel.alpha = 0.5;
        cell.statusImageView.hidden = YES;
        cell.statusSelectedImageView.hidden = NO;
        [self.tagsArray addObject:self.dataShowArray [indexPath.row]];
       
        [self.tagsView addTag:cell.titleLabel.text];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.2)];
        topLineView.backgroundColor = tableView.separatorColor;
        [cell.contentView addSubview:topLineView];
    }
    
    if(indexPath.row == ([self.dataShowArray count]- 1))
    {
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height, self.view.bounds.size.width, 0.2)];
        topLineView.backgroundColor = tableView.separatorColor;
        [cell.contentView addSubview:topLineView];
    }
    // Remove seperator inset
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}


- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

#pragma mark - UIButton Actions

- (IBAction)didTapOnSearchDoneButton:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:self.tagsArray forKey:@"subjects"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.delegate getSubjects:self.tagsArray];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
