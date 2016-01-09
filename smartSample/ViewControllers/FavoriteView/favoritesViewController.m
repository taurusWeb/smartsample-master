//
//  favoritesViewController.m
//  
//
//  Created by Leela Electronics on 29/12/15.
//
//

#import "favoritesViewController.h"
#import "favoriteTableViewCell.h"
#import "commonClass.h"

@interface favoritesViewController ()

@end

@implementation favoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                   {
                       
                       NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/forum/list"];
                       
                       self.dataArray =  [commonClass get:urlString];
                       if([self.dataArray count])
                       {
                           self.dataShowArray = [self.dataArray mutableCopy];
                       }
                       else
                       {
                           self.dataShowArray = [[NSMutableArray alloc]init];;
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [self.favoritesTableView reloadData];
                                      });
                   });

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    favoriteTableViewCell * cell = (favoriteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"favoriteCell"];
    
    if(cell == nil)
    {
        cell = [[favoriteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favoriteCell"];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    
    
    NSString *author= [[self.dataArray [indexPath.section] valueForKey:@"sub"] [indexPath.row] valueForKey:@"post_username"];
    NSString *date= [[self.dataArray [indexPath.section] valueForKey:@"sub"] [indexPath.row] valueForKey:@"post_time"];
        
        NSDictionary *arialDictDate = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"GothamRounded-Book" size:9] forKey:NSFontAttributeName];
        NSMutableAttributedString *attrStingDate = [[NSMutableAttributedString alloc] initWithString:date attributes:arialDictDate];

        NSUInteger length = [author length];

        NSMutableAttributedString *attrStringAuthor= [[NSMutableAttributedString alloc] initWithString:author attributes:arialDictDate];
        
        [attrStringAuthor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length)];
        
        
        NSMutableAttributedString *semiStr = [[NSMutableAttributedString alloc] initWithString:@", by "];
        
        [attrStingDate appendAttributedString:semiStr];
        [attrStingDate appendAttributedString:attrStringAuthor];
    
    
     cell.mainHeadLabel.text = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [indexPath.row] valueForKey:@"forum_name"];
  
    
        
    cell.subHeadLabel.attributedText = attrStingDate;
    
    
    
    
  //  cell.titleLabel.text = self.dataShowArray [indexPath.row];
    
    return cell;
}



- (IBAction)didTapOnBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
