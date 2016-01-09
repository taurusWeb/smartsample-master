

#import "searchSchoolViewController.h"
#import "searchSchoolTableViewCell.h"
#import "commonClass.h"

#define RGB(r,g,b,a)		[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define COMMON_RADIUS       10

@interface searchSchoolViewController ()
{
    BOOL TagFlagValue;
}
@end

@implementation searchSchoolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    TagFlagValue = YES;
   
    self.searchImageView.layer.cornerRadius = COMMON_RADIUS;
    self.searchImageView.layer.borderColor = RGB(107, 191, 228, 1).CGColor;;
    self.searchImageView.layer.borderWidth = 1.5f;
    self.searchTagView.tagsBackgroundColor = [UIColor colorWithRed:(103.0f/255.0f) green:(205.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0];
    self.searchTagView.tagsDeleteButtonColor = [UIColor whiteColor];
    self.searchTagView.tagsTextColor = [UIColor whiteColor];
    self.searchTagView.mode = TLTagsControlModeEdit;
    self.searchTagView.tapDelegate = self;
    
    if(!([[NSUserDefaults standardUserDefaults]objectForKey:@"school"]== nil))
    {
        [self.searchTagView addTag:[[[NSUserDefaults standardUserDefaults]objectForKey:@"school"]valueForKey:@"school_name"]];
        self.tagsArray = [NSMutableArray arrayWithObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"school"]];
    }
    else
    {
        self.tagsArray = [[NSMutableArray alloc]init];
    }
    
    
    [self.searchTagView reloadTagSubviews];
    
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

        NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/school/get"];
        
        self.dataArray =  [commonClass get:urlString];
        if([self.dataArray count])
        {
             self.dataShowArray = [NSMutableArray arrayWithArray:self.dataArray];
        }
        else
        {
            self.dataShowArray = [[NSMutableArray alloc]init];;
        }
        
    });
    
    self.schoolTableView.hidden = YES;
    self.emptyImageView.hidden = NO;
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLayoutSubviews
{
    if((self.searchTagView.contentSize.width > self.searchTagView.bounds.size.width) && (TagFlagValue))
    {
        CGPoint bottomOffset = CGPointMake(self.searchTagView.contentSize.width - self.searchTagView.bounds.size.width,0);
        [self.searchTagView setContentOffset:bottomOffset animated:YES];
        TagFlagValue = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma mark - TLTagsControl DelegateMethods

- (void)removedTag:(NSString *)string
{
    
    for (int i = 0; i < [self.tagsArray count]; i++)
    {
        if([[self.tagsArray valueForKey:@"school_name"][i] isEqualToString:string])
        {
            [self.tagsArray removeObjectAtIndex:i];
        }
    }
}

- (void)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacedString:(NSString *)string
{
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(searchStr.length > 0)
    {
        if([self.dataArray count])
        {
            
            NSMutableArray * filterArray = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < [[self.dataArray valueForKey:@"school_name"]count]; i++)
            {
                
                if ([[self.dataArray valueForKey:@"school_name"] [i]rangeOfString:searchStr  options:NSCaseInsensitiveSearch].location !=   NSNotFound)
                {
                    [filterArray addObject:self.dataArray [i]];
                }
            }
            
            self.dataShowArray = [filterArray mutableCopy];
        }
        
        
        if([self.dataShowArray count] && [self.schoolTableView isHidden])
        {
            self.schoolTableView.hidden = NO;
            self.emptyImageView.hidden = YES;
        }
        
    }
    else
    {
        if([self.dataArray count])
        {
            self.dataShowArray = [NSMutableArray arrayWithArray:self.dataArray];
        }
        
        if(![self.schoolTableView isHidden])
        {
            self.schoolTableView.hidden = YES;
            self.emptyImageView.hidden = NO;
        }
    }
    
    [self.schoolTableView reloadData];
    
}

#pragma mark - UITextField DelegateMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


# pragma mark - UITableView DelegateMethods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.dataShowArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    searchSchoolTableViewCell * cell = (searchSchoolTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"schoolCell"];

    if(cell == nil)
    {
        cell = [[searchSchoolTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"schoolCell"];
        
    }
    BOOL containsValue = NO;
    
    for (int i = 0; i < [self.tagsArray count]; i++)
    {
        if([[self.tagsArray valueForKey:@"school_name"][i] isEqualToString:[self.dataShowArray valueForKey:@"school_name"][indexPath.row]])
        {
            containsValue = YES;
        }
    }
    if(containsValue)
    {
        cell.titleLabel.alpha = 0.5;
    }
    else
    {
        cell.titleLabel.alpha = 1;
    }
    cell.titleLabel.text = [self.dataShowArray valueForKey:@"school_name"] [indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //searchSchoolTableViewCell * cell = (searchSchoolTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    if(![self.tagsArray count])
    {
        [self.tagsArray  addObject:self.dataShowArray[indexPath.row]];
    }
    else
    {
        [self.tagsArray  removeAllObjects];
        [self.tagsArray addObject:self.dataShowArray [indexPath.row]];
    }
    
    [self.searchTagView addTags:[self.tagsArray valueForKey:@"school_name"]];
    [self.searchTagView reloadTagSubviews];
   
    [tableView reloadData];
    if([self.tagsArray count])
    {
        [[NSUserDefaults standardUserDefaults]setObject:self.tagsArray [0] forKey:@"school"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.delegate getSchool:self.tagsArray [0]];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"school"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.delegate getSchool:self.tagsArray];
    }
    [self.navigationController popViewControllerAnimated:YES];

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

# pragma mark - UIButton Actions

- (IBAction)didTapOnSearchDoneButton:(UIButton *)sender
{
    if([self.tagsArray count])
    {
        [[NSUserDefaults standardUserDefaults]setObject:self.tagsArray [0] forKey:@"school"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        [self.delegate getSchool:self.tagsArray [0]];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"school"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.delegate getSchool:self.tagsArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
