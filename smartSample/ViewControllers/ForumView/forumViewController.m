

#import "forumViewController.h"
#import "forumTableViewCell.h"
#import "favoritesViewController.h"
#import "addPostViewController.h"
#import "PostModel.h"
#import "commonClass.h"

@interface forumViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation forumViewController
#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchTextField.layer.cornerRadius = 5.0;
    self.searchTextField.clipsToBounds = YES;
    
    
    if(_fbLoginStaus==YES)
    {
        NSUserDefaults *fbDefaultToken = [NSUserDefaults standardUserDefaults];
        NSString *fbToken;
        
        if (fbDefaultToken)
        {
            fbToken = (NSString*)[fbDefaultToken objectForKey:@"fb_access_Token"];
            NSLog(@"facebook token is %@", fbToken);
            
            
        }
    }
    else if (_otherLoginStatus==YES)
    {
        NSUserDefaults *laultToken = [NSUserDefaults standardUserDefaults];
        NSString *loginToken;
        
        if (laultToken)
        {
            loginToken = (NSString*)[laultToken objectForKey:@"login_access_Token"];
            NSLog(@"login  token is %@", loginToken);
        }
        
    }
    
    UIView* left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, self.searchTextField.frame.size.height)];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = left;
    
    
    
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
            [self.forumTableView reloadData];
        });
    });
   
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField DelegateMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


#pragma mark - UITableView DelegateMethods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    // create the parent view that will hold header Label
    UIView* customView;
    if(section == 0)
    {
        customView = [[UIView alloc]initWithFrame:CGRectMake(10.0, 0.0, [[UIScreen mainScreen]bounds].size.width, 38.0)];
    }
    else
    {
        customView = [[UIView alloc]initWithFrame:CGRectMake(10.0, 0.0, [[UIScreen mainScreen]bounds].size.width, 44.0)];
    }
   // UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, [[UIScreen mainScreen]bounds].size.width, 44.0)];
    if(section < 2)
    {
        UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        headerBtn.backgroundColor = [UIColor clearColor];
        headerBtn.opaque = NO;
        if(section == 0)
        {
            headerBtn.frame = CGRectMake(customView.frame.size.width - 46 , 17, 30.0, 12.0);
        }
        else
        {
            headerBtn.frame = CGRectMake(customView.frame.size.width - 46 , 23, 30.0, 12.0);
        }
        [headerBtn setTitle:@"See all" forState:UIControlStateNormal];
        headerBtn.titleLabel.font = [UIFont fontWithName:@"GothamRounded-Medium" size:9];
        [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [headerBtn addTarget:self action:@selector(didTapOnSeeAllButton:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:headerBtn];
    }

    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    if(section == 0)
    {
        headerLabel.frame = CGRectMake(16 , 13, customView.frame.size.width - 72, 20.0);
    }
    else
    {
         headerLabel.frame = CGRectMake(16 , 19, customView.frame.size.width - 72, 20.0);
    }
    if(section == 0)
    {
        headerLabel.text =  [NSString stringWithFormat:@"%@ 🕑", [self.dataArray[section] valueForKey:@"heading"]];
        headerLabel.alpha = 1;
    }
    else if (section == 1)
    {
        headerLabel.text = [NSString stringWithFormat:@"%@ 🌟", [self.dataArray[section] valueForKey:@"heading"]];
        headerLabel.alpha =  1;
    }
    else
    {
        headerLabel.text = [self.dataArray[section] valueForKey:@"heading"];
        headerLabel.alpha =  0.49f;
    }
    headerLabel.font = [UIFont fontWithName:@"GothamRounded-Medium" size:14];
    headerLabel.textColor = [UIColor blackColor];
    [customView addSubview:headerLabel];
        
    return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 38;
    }
    else
    {
        return 44;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [self.dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < 2)
    {
        return  1;
    }
    return [[self.dataArray [section] valueForKey:@"sub"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < 2)
    {
        
        forumTableViewCell * cell = (forumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"forumStartupCell"];
        
        if(cell == nil)
        {
            cell = [[forumTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"forumStartupCell"];
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        for (int i = 0; i < [[self.dataArray [indexPath.section] valueForKey:@"sub"]count] ; i++)
        {
            
          
        }
        
        cell.dotImageView1.layer.cornerRadius = 2;
        cell.dotImageView2.layer.cornerRadius = 2;
        cell.dotImageView3.layer.cornerRadius = 2;
        cell.dotImageView4.layer.cornerRadius = 2;
    
        cell.titleLabel1.text = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [0] valueForKey:@"post_subject"];
        cell.titleLabel2.text = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [1] valueForKey:@"post_subject"];
        cell.titleLabel3.text = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [2] valueForKey:@"post_subject"];
        cell.titleLabel4.text = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [3] valueForKey:@"post_subject"];
        
        
        
        
        NSString *author1 = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [0] valueForKey:@"post_username"];
        NSString *date1 = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [0] valueForKey:@"post_time"];
        
        NSString *author2 = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [1] valueForKey:@"post_username"];
        NSString *date2 = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [1] valueForKey:@"post_time"];
        
        NSString *author3 = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [2] valueForKey:@"post_username"];
        NSString *date3 = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [2] valueForKey:@"post_time"];
        
        NSString *author4 = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [3] valueForKey:@"post_username"];
        NSString *date4 = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [3] valueForKey:@"post_time"];
        
        
        
        //1st sub title
        NSDictionary *arialDictDate = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"GothamRounded-Book" size:9] forKey:NSFontAttributeName];
        
        NSMutableAttributedString *attrStingDate = [[NSMutableAttributedString alloc] initWithString:date1 attributes:arialDictDate];
        
        NSMutableAttributedString *attrStingDate2 = [[NSMutableAttributedString alloc] initWithString:date2 attributes:arialDictDate];
        NSMutableAttributedString *attrStingDate3 = [[NSMutableAttributedString alloc] initWithString:date3 attributes:arialDictDate];
        NSMutableAttributedString *attrStingDate4 = [[NSMutableAttributedString alloc] initWithString:date4 attributes:arialDictDate];
        
        NSUInteger length = [author1 length];
        NSUInteger length2 = [author2 length];
        NSUInteger length3 = [author3 length];
        NSUInteger length4 = [author4 length];
        
        
        NSMutableAttributedString *attrStringAuthor= [[NSMutableAttributedString alloc] initWithString:author1 attributes: arialDictDate];
        [attrStringAuthor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length)];
        
        NSMutableAttributedString *attrStringAuthor2= [[NSMutableAttributedString alloc] initWithString:author2 attributes: arialDictDate];
        [attrStringAuthor2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length2)];
        
        NSMutableAttributedString *attrStringAuthor3= [[NSMutableAttributedString alloc] initWithString:author3 attributes: arialDictDate];
        [attrStringAuthor3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length3)];
        
        
        NSMutableAttributedString *attrStringAuthor4= [[NSMutableAttributedString alloc] initWithString:author4 attributes: arialDictDate];
        [attrStringAuthor4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length4)];
        
        //second subtitle
        
        NSMutableAttributedString *semiStr = [[NSMutableAttributedString alloc] initWithString:@", by "];
        
        [attrStingDate appendAttributedString:semiStr];
        [attrStingDate appendAttributedString:attrStringAuthor];
        
        [attrStingDate2 appendAttributedString:semiStr];
        [attrStingDate2 appendAttributedString:attrStringAuthor2];
        
        [attrStingDate3 appendAttributedString:semiStr];
        [attrStingDate3 appendAttributedString:attrStringAuthor3];
        
        [attrStingDate4 appendAttributedString:semiStr];
        [attrStingDate4 appendAttributedString:attrStringAuthor4];
        
        cell.subTitleLabel1.attributedText = attrStingDate;
        cell.subTitleLabel2.attributedText=attrStingDate2;
        cell.subTitleLabel3.attributedText=attrStingDate3;
        cell.subTitleLabel4.attributedText=attrStingDate4;
        
        
    return  cell;
        
    }
    else
    {
        forumTableViewCell * cell = (forumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"forumDefaultCell"];
        if(cell == nil)
        {
            cell = [[forumTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"forumDefaultCell"];
        }
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.titleLabel.text = [[self.dataArray [indexPath.section] valueForKey:@"sub"] [indexPath.row] valueForKey:@"forum_name"];
        cell.subTitleLabel.text = @" 100 Topics and 10 replies";
        
        return cell;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section < 2)
    {
        return 174.0;
    }
    // "Else"
    return 55;
}


#pragma mark - UIButton Actions

- (IBAction)didTapOnSeeAllButton:(UIButton *)sender
{
    NSLog(@"Button Tapped");
}

- (IBAction)didTapOnAddButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"addPostView"];
    UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    navigation.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:navigation animated:YES completion:nil];
    
}



@end
