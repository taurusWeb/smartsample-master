

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
            PostModel *postObject=[[PostModel alloc]init];
            NSDictionary *recentDict=[postObject recentPost:loginToken];
            _recentPostArray = [recentDict valueForKey:@"topic_title"];
            _recentPostArrayAuthor=[recentDict valueForKey:@"post_username"];
            _recentPostTimeArray=[recentDict valueForKey:@"post_time"];
            
            NSDictionary *topPostDic=[postObject topPost:_user_accessToken];
            NSLog(@" %@",topPostDic);
           
                
           _topPostAray=[topPostDic valueForKey:@"topic_title"];
            _topPostArrayAuthor=[topPostDic valueForKey:@"post_username"];
            _topPostArrayTime=[topPostDic valueForKey:@"post_time"];
                
                
         
            
        }
        
    }
    // post_username
    //post_time
    
    UIView* left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, self.searchTextField.frame.size.height)];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = left;
 
    
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
        
        if(indexPath.section==0)
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
            
            cell.titleLabel1.text=_recentPostArray[0];
            cell.titleLabel2.text=_recentPostArray[1];
            cell.titleLabel3.text=_recentPostArray[2];
            
            NSString *author1=_recentPostArrayAuthor[0];
            NSString *date1=_recentPostTimeArray[0];
            
            NSString *author2=_recentPostArrayAuthor[1];
            
            NSString *date2=_recentPostTimeArray[1];
            NSString *author3=_recentPostArrayAuthor[2];
            NSString *date3=_recentPostTimeArray[2];
            
                      
         
          
           
            //1st sub title
            NSDictionary *arialDictDate = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"GothamRounded-Book" size:9] forKey:NSFontAttributeName];
            
            NSMutableAttributedString *attrStingDate = [[NSMutableAttributedString alloc] initWithString:date1 attributes:arialDictDate];
            NSMutableAttributedString *attrStingDate2 = [[NSMutableAttributedString alloc] initWithString:date2 attributes:arialDictDate];
            NSMutableAttributedString *attrStingDate3 = [[NSMutableAttributedString alloc] initWithString:date3 attributes:arialDictDate];

            
            NSDictionary *arialDictAuthor = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"GothamRounded-Book" size:9] forKey:NSFontAttributeName ];
            
            NSUInteger length = [author1 length];
            NSUInteger length2 = [author2 length];
            NSUInteger length3 = [author3 length];

            
            NSMutableAttributedString *attrStringAuthor= [[NSMutableAttributedString alloc] initWithString:author1 attributes: arialDictAuthor];
            [attrStringAuthor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length)];
            
            NSMutableAttributedString *attrStringAuthor2= [[NSMutableAttributedString alloc] initWithString:author2 attributes: arialDictAuthor];
            [attrStringAuthor2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length2)];
            
            NSMutableAttributedString *attrStringAuthor3= [[NSMutableAttributedString alloc] initWithString:author3 attributes: arialDictAuthor];
            [attrStringAuthor3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length3)];
            
            
            
            double unixTimeStamp =1304245000;
            NSTimeInterval _interval=unixTimeStamp;
            NSDate *kittiyadate = [NSDate dateWithTimeIntervalSince1970:_interval];
            NSDate *innathedate=[NSDate date];
            
            NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"dd.MM.yyyy HH:MM:SS"];
            NSString *dateString = [formatter stringFromDate:kittiyadate];
            
            unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
            
            NSCalendar*calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:flags fromDate:kittiyadate];
            NSDate* dateOnly = [[calendar dateFromComponents:components] dateByAddingTimeInterval:[[NSTimeZone localTimeZone]secondsFromGMT]];

            
            NSLog(@"date %@",dateString);
            
            
            //second subtitle
            
            NSMutableAttributedString *semiStr = [[NSMutableAttributedString alloc] initWithString:@", by "];

            [attrStingDate appendAttributedString:semiStr];
            [attrStingDate appendAttributedString:attrStringAuthor];

            [attrStingDate2 appendAttributedString:semiStr];
            [attrStingDate2 appendAttributedString:attrStringAuthor2];
            
            [attrStingDate3 appendAttributedString:semiStr];
            [attrStingDate3 appendAttributedString:attrStringAuthor3];
            
            
            
            cell.subTitleLabel1.attributedText = attrStingDate;
            cell.subTitleLabel2.attributedText=attrStingDate2;
            cell.subTitleLabel3.attributedText=attrStingDate3;
            
           
            
            
            
            
            return  cell;
        }
        else
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
            
            cell.titleLabel1.text=_topPostAray[0];
            cell.titleLabel2.text=_topPostAray[1];
            cell.titleLabel3.text=_topPostAray[2];
            
            
            NSString *author1=_topPostArrayAuthor[0];
            NSString *date1=_topPostArrayTime[0];
            
            NSString *author2=_topPostArrayAuthor[1];
            NSString *date2=_topPostArrayTime[1];
            NSString *author3=_topPostArrayAuthor[2];
            NSString *date3=_topPostArrayTime[2];
            
            
            
            //1st sub title
            NSDictionary *arialDictDate = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"GothamRounded-Book" size:9] forKey:NSFontAttributeName];
            
            NSMutableAttributedString *attrStingDate = [[NSMutableAttributedString alloc] initWithString:date1 attributes:arialDictDate];
            NSMutableAttributedString *attrStingDate2 = [[NSMutableAttributedString alloc] initWithString:date2 attributes:arialDictDate];
            NSMutableAttributedString *attrStingDate3 = [[NSMutableAttributedString alloc] initWithString:date3 attributes:arialDictDate];
            
            
            NSDictionary *arialDictAuthor = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"GothamRounded-Book" size:9] forKey:NSFontAttributeName ];
            
            NSUInteger length = [author1 length];
            NSUInteger length2 = [author2 length];
            NSUInteger length3 = [author3 length];
            
            
            NSMutableAttributedString *attrStringAuthor= [[NSMutableAttributedString alloc] initWithString:author1 attributes: arialDictAuthor];
            [attrStringAuthor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length)];
            
            NSMutableAttributedString *attrStringAuthor2= [[NSMutableAttributedString alloc] initWithString:author2 attributes: arialDictAuthor];
            [attrStringAuthor2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length2)];
            
            NSMutableAttributedString *attrStringAuthor3= [[NSMutableAttributedString alloc] initWithString:author3 attributes: arialDictAuthor];
            [attrStringAuthor3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/256.0f green:205.0f/256.0f blue:236.0f/256.0f alpha:1] range:NSMakeRange(0,length3)];
            
            
            
           
            
          
            NSMutableAttributedString *semiStr = [[NSMutableAttributedString alloc] initWithString:@", by "];
            
            [attrStingDate appendAttributedString:semiStr];
            [attrStingDate appendAttributedString:attrStringAuthor];
            
            [attrStingDate2 appendAttributedString:semiStr];
            [attrStingDate2 appendAttributedString:attrStringAuthor2];
            
            [attrStingDate3 appendAttributedString:semiStr];
            [attrStingDate3 appendAttributedString:attrStringAuthor3];
            
            
            
            cell.subTitleLabel1.attributedText = attrStingDate;
            cell.subTitleLabel2.attributedText=attrStingDate2;
            cell.subTitleLabel3.attributedText=attrStingDate3;
            
            
            
            
            return  cell;
        }
        
        
        
        
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
