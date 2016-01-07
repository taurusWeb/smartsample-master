

#import "forumViewController.h"
#import "forumTableViewCell.h"
#import "favoritesViewController.h"
#import "UIViewController+MHSemiModal.h"
#import "addPostViewController.h"
#import "PostModel.h"

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
    
   /*
    NSUserDefaults *access_default = [NSUserDefaults standardUserDefaults];
    if (access_default)
    {
        _user_accessToken = (NSString*)[access_default objectForKey:@"access_token"];
    }
    PostModel *postObject=[[PostModel alloc]init];
    NSDictionary *recentDict=[postObject recentPost:_user_accessToken];
   // NSLog(@"recent post dictionary is %@",recentDict);
    
    NSDictionary *topPostDic=[postObject topPost:_user_accessToken];
    //NSLog(@"top post dictionary iss %@",topPostDic);
  
    */
    
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
        headerLabel.text = @"Recent Posts 🕑";
        headerLabel.alpha = 1;
    }
    else if (section == 1)
    {
        headerLabel.text = @"Top Posts 🌟";
        headerLabel.alpha =  1;
    }
    else
    {
        headerLabel.text = @"Headings";
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
    return  10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < 2)
    {
        return  1;
    }
    return 3;
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
        cell.dotImageView1.layer.cornerRadius = 2;
        cell.dotImageView2.layer.cornerRadius = 2;
        cell.dotImageView3.layer.cornerRadius = 2;
        cell.dotImageView4.layer.cornerRadius = 2;
        
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
        // cell.titleLabel.text = self.dataShowArray [indexPath.row];
        
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
 //   rootViewController.modalPresentationStyle = UIModalPresentationCustom;
    UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    //navigation.modalPresentationStyle   = UIModalPresentationCustom;
    navigation.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:navigation animated:YES completion:nil];
    
}



@end
