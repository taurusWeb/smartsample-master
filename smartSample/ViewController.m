

#import "ViewController.h"
#import "PostModel.h"
#import "commonClass.h"
#import "SignUPModel.h"

#import "createProfileViewController.h"
#import "forumViewController.h"
#import "mainTabBarViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>



BOOL fbLogin=NO;
BOOL otherlogin=NO;
BOOL fbSignUP=NO;
BOOL otherSignUP=NO;

BOOL fbLoginButton=NO;
BOOL fbSignUPButton=YES;

@interface ViewController ()<UITextFieldDelegate>
{
    NSInteger flagValue;
}
@end

@implementation ViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // clearing default valuess
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"subjects"] || [[NSUserDefaults standardUserDefaults]objectForKey:@"school"] )
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"subjects"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"school"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"login_access_Token"] )
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"login_access_Token"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"user_name"] || [[NSUserDefaults standardUserDefaults]objectForKey:@"user_fbId"]|| [[NSUserDefaults standardUserDefaults]objectForKey:@"user_image"] )
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_fbId"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_image"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"fb_access_Token"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fb_access_Token"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"email_address"] || [[NSUserDefaults standardUserDefaults]objectForKey:@"pasword"] )
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"email_address"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"pasword"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
    NSAttributedString *emailStringPlaceholder = [[NSAttributedString alloc] initWithString:@"email address" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:(103.0f/255.0f) green:(205.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0]}];
    
    self.emailTextField.attributedPlaceholder =emailStringPlaceholder;
    
    NSAttributedString *passwordStringPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:(103.0/255.0) green:(205.0/255.0) blue:(236.0/255.0) alpha:1.0]}];
    self.passwordTextField.attributedPlaceholder=passwordStringPlaceholder;

    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOntapGesture:)];
    [self.view addGestureRecognizer:gesture];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
 
    
    [self loginSection];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    self.loginButton.selected = NO;
    self.signupButton.selected = YES;
    
    self.signupDropUpImageView.hidden = NO;
    [self.signupButton setTitleColor :[UIColor colorWithRed:(103.0/255.0) green:(205.0/255.0) blue:(236.0/255.0) alpha:1.0]forState:UIControlStateNormal];
    
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginDropUpImageView.hidden = YES;
    
    flagValue = 1;
    
    self.forgotButton.hidden = YES;
    self.loginMainButton.hidden = YES;
    self.createAcoountButton.hidden = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
}



#pragma mark - Private Methoods

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.signupScrollView.contentInset = contentInsets;
    self.signupScrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.signupScrollView.contentInset = contentInsets;
    self.signupScrollView.scrollIndicatorInsets = contentInsets;
}



#pragma mark - UItextField DelegateMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


#pragma mark - UIButton Actions

- (IBAction)didTapOnSignUpButton:(UIButton *)sender
{
    if(!(flagValue == 1))
    {
        if(sender.selected == NO)
        {
            [sender setTitleColor:[UIColor colorWithRed:(103.0/255.0) green:(205.0/255.0) blue:(236.0/255.0) alpha:1.0] forState:UIControlStateNormal];
            self.signupDropUpImageView.hidden = NO;
            [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.loginDropUpImageView.hidden = YES;
          
            sender.selected = YES;
            self.loginButton.selected = NO;
            
            self.forgotButton.hidden = YES;
            self.loginMainButton.hidden = YES;
            self.createAcoountButton.hidden = NO;
            [self.view endEditing:YES];
            self.signupScrollView.contentOffset = CGPointZero;
            fbLoginButton=NO;
            fbSignUPButton=YES;
            
            for (id loginObject in _loginView.subviews)
            {
                if ([loginObject isKindOfClass:[UIButton class]])
                {
                    UIButton * loginButton =  loginObject;
                    
                    UIImage *loginImage = [UIImage imageNamed:@"rectangle6FB"];
                    [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
                    [loginButton setTitle:@"sign up using facebook" forState:UIControlStateNormal];
                    loginButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
                    [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
                    [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
                }
                if ([loginObject isKindOfClass:[UILabel class]])
                {
                    UILabel * loginLabel =  loginObject;
                    loginLabel.text = @"";
                    loginLabel.frame = CGRectMake(0, 0, 0, 0);
                }
            }
            _loginView.delegate = self;
        }
        
        flagValue = 1;
    }
    
}

- (IBAction)didTapOnLoginButton:(UIButton *)sender
{
    if(!(flagValue == 2))
    {
        if (sender.selected == NO)
        {
            [sender setTitleColor:[UIColor colorWithRed:(103.0/255.0) green:(205.0/255.0) blue:(236.0/255.0) alpha:1.0] forState:UIControlStateNormal];
            self.loginDropUpImageView.hidden = NO;
            [self.signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.signupDropUpImageView.hidden = YES;
        
            sender.selected = YES;
            self.signupButton.selected = NO;
            
            self.forgotButton.hidden = NO;
            self.loginMainButton.hidden = NO;
            self.createAcoountButton.hidden = YES;
            [self.view endEditing:YES];
            self.signupScrollView.contentOffset = CGPointZero;
            fbLoginButton=YES;
            fbSignUPButton=NO;
            
            
            for (id loginObject in _loginView.subviews)
            {
                if ([loginObject isKindOfClass:[UIButton class]])
                {
                    UIButton * loginButton =  loginObject;
                    
                    UIImage *loginImage = [UIImage imageNamed:@"rectangle6FB"];
                    [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
                    [loginButton setTitle:@"login using facebook" forState:UIControlStateNormal];
                    loginButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
                    [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
                    [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
                }
                if ([loginObject isKindOfClass:[UILabel class]])
                {
                    UILabel * loginLabel =  loginObject;
                    loginLabel.text = @"";
                    loginLabel.frame = CGRectMake(0, 0, 0, 0);
                }
            }
            
            _loginView.delegate = self;

        }
        
        flagValue = 2;
    }
}

- (IBAction)didTapOnCreateAccountButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([_emailTextField.text isEqualToString:@""]&&[_passwordTextField.text isEqualToString:@""])
    {
        [[[UIAlertView alloc]initWithTitle:@" " message:@"please enter email and password" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
    }
    else
    {
        
        if ([_emailTextField.text isEqualToString:@""])
        {
            [[[UIAlertView alloc]initWithTitle:@"email is missing!" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
        }
        else
        {
            // email regex checking
            NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
            if (![emailTest evaluateWithObject:_emailTextField.text] == YES)
            {
                [[[UIAlertView alloc]initWithTitle:@" " message:@"please enter a valid email address" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
            }
            else
            {
                if([_passwordTextField.text isEqualToString:@""] )
                {
                    [[[UIAlertView alloc]initWithTitle:@"password" message:@"missing password" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
                }
                else
                {
                    
                    SignUPModel *emailChekingObject=[[SignUPModel alloc]init];
                    NSDictionary *dct=[emailChekingObject signupUserCheking:_emailTextField.text ];
                    NSNumber *status = [dct valueForKey:@"status_code"];
                    if ([status isEqualToNumber:@0])
                    {
                        otherSignUP=YES;

                        
                            NSUserDefaults *signupDefault = [NSUserDefaults standardUserDefaults];
                            if (signupDefault)
                            {
                                [signupDefault setObject: _emailTextField.text forKey:@"email_address"];
                                [signupDefault setObject: _passwordTextField.text forKey:@"pasword"];
                                [signupDefault synchronize];
                            }
                        [self performSegueWithIdentifier:@"createAccountSegue" sender:self];
                        
                        
                    }
                    else
                    {
                        [[[UIAlertView alloc]initWithTitle:@"user already exist !" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
                    }
                }
            }
        }
    }
    

}



- (IBAction)didTapOnLoginMainButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    // textfield validations..
    
    if ([_emailTextField.text isEqualToString:@""]&&[_passwordTextField.text isEqualToString:@""])
    {
        [[[UIAlertView alloc]initWithTitle:@" " message:@"please enter email and password" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
    }
    else
    {
        
        if ([_emailTextField.text isEqualToString:@""])
        {
            [[[UIAlertView alloc]initWithTitle:@"email is missing!" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
        }
        else
        {
            // email regex checking
            NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
            if (![emailTest evaluateWithObject:_emailTextField.text] == YES)
            {
                [[[UIAlertView alloc]initWithTitle:@" " message:@"please enter a valid email address" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
            }
            else
            {
                if([_passwordTextField.text isEqualToString:@""] )
                {
                    [[[UIAlertView alloc]initWithTitle:@"password" message:@"missing password" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
                }
                else
                {
                    SignUPModel *loginModelObject=[[SignUPModel alloc]init];
                    NSDictionary *dct=[loginModelObject doLogin:_emailTextField.text password:_passwordTextField.text];
                    NSNumber *status = [dct valueForKey:@"status_code"];
                    NSString *access_code=[dct valueForKey:@"access_token"];
  
                    if ([status isEqualToNumber:@1])
                    {
                        otherlogin=YES;
                        
                        NSUserDefaults *access_tokenDefaultLogin = [NSUserDefaults standardUserDefaults];
                        if (access_tokenDefaultLogin)
                        {
                            [access_tokenDefaultLogin setObject:access_code forKey:@"login_access_Token"];
                            [access_tokenDefaultLogin synchronize];
                        }
                      // login success
                      [self performSegueWithIdentifier:@"segueLogin" sender:self];
                        
                    }
                    else
                    {
                        [[[UIAlertView alloc]initWithTitle:@"login failed  !" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
                    }
                }
            }
        }
    }
    

}

- (IBAction)didTapOnForgotButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Enter your email address in order to receive a reset link. " message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send Link",nil];
    
    alert.alertViewStyle= UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
    alertTextField.returnKeyType = UIReturnKeyDone;
    [alert show];

}

- (IBAction)didTapOnLoginFbMainButton:(UIButton *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITapGesture Method
- (void)didTapOntapGesture:(UIGestureRecognizer *) gesture
{
    [self.view endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
        UITextField *textField = [alertView textFieldAtIndex:0];
        [textField setPlaceholder:@"Email.."];
        
        /*
         *regex checking of the email id   !
         */
        NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
        
        if (([emailTest evaluateWithObject:textField.text] != YES) || [textField.text isEqualToString:@""])
        {
            UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@" Enter Email in" message:@"abc@example.com format" delegate:self
                                                       cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [loginalert show];
        }
        else
        {
            /*
             * code for store the email address  into the json admin tb
             */
            //forgotpassword
                SignUPModel *forgetObject=[[SignUPModel alloc]init];
                NSDictionary *dct=[forgetObject forgotpassword:textField.text];
                NSNumber *status = [dct valueForKey:@"status_code"];
                if ([status isEqualToNumber:@1])
                {
                    UIAlertView *myAlertView =[[UIAlertView alloc]initWithTitle:@"Rest link will be sent to your email" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil];
                    [myAlertView show];
                }
                else
                {
                UIAlertView *myAlertView =[[UIAlertView alloc]initWithTitle:@"Enter a valid email ... !!" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil];
                    [myAlertView show];
                }
        }
    }
    else
    {
        
    }
}
-(void)loginSection
{
    self.loginView.readPermissions=@[@"public_profile",@"email",@"user_friends"];
    
    for (id loginObject in _loginView.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  loginObject;
            
            UIImage *loginImage = [UIImage imageNamed:@"rectangle6FB"];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setTitle:@"sign up using facebook" forState:UIControlStateNormal];
            
            loginButton.font = [UIFont fontWithName:@"GothamRounded-Medium" size:18];
            //  [loginButton setFont:[UIFont fontWithName:@"GothamRounded-Medium" size:18]];
            loginButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        }
        if ([loginObject isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  loginObject;
            loginLabel.text = @"";
            loginLabel.frame = CGRectMake(0, 0, 0, 0);
        }
    }
    _loginView.delegate = self;
    
    // [self.view addSubview:_loginView];
}



// fb section

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    
    
    NSString *firstName = user.name;
    // NSLog(@"User details =%@",user);
    NSString *facebookId = user.objectID;
    // NSLog(@"User details =%@",firstName);
    //  NSLog(@"User details =%@",facebookId);
    // NSLog(@"Facebook id  %@",facebookId);
    NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
    // NSLog(@"Photo url id  %@",imageUrl);
    
    if(fbLoginButton==YES)
    {
        SignUPModel *fbLoginObject=[[SignUPModel alloc]init];
        NSDictionary *dct=[fbLoginObject fbLoginAction:facebookId];
        NSNumber *status = [dct valueForKey:@"status_code"];
        NSString *access_tokenFBLogin=[dct valueForKey:@"access_token"];
        
        NSLog(@"status %@",status);
        if ([status isEqualToNumber:@1])
        {
            NSUserDefaults *fbDefaultToken = [NSUserDefaults standardUserDefaults];
            if (fbDefaultToken)
            {
                [fbDefaultToken setObject:access_tokenFBLogin forKey:@"fb_access_Token"];
                
                [fbDefaultToken synchronize];
            }
             [self performSegueWithIdentifier:@"segueLogin" sender:self];
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"please enter facebook id " message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
            
        }
        
    }
    else if (fbSignUPButton==YES)
    {
        
        SignUPModel *facebookSignup=[[SignUPModel alloc]init];
        NSDictionary *dct=[facebookSignup fbIDCheking:facebookId];
        NSNumber *status = [dct valueForKey:@"status_code"];
        if ([status isEqualToNumber:@0])
        {
            
            
            NSUserDefaults *fbDefault = [NSUserDefaults standardUserDefaults];
            if (fbDefault)
            {
                [fbDefault setObject:firstName forKey:@"user_name"];
                [fbDefault setObject:facebookId forKey:@"user_fbId"];
                [fbDefault setObject:imageUrl forKey:@"user_image"];
                
                [fbDefault synchronize];
            }
            fbSignUP=YES;

            [self performSegueWithIdentifier:@"createAccountSegue" sender:self];
        }
        else
        {
            
            fbLogin=YES;
            /*
             * facebook login
             
             */
            
            SignUPModel *fbLoginObject=[[SignUPModel alloc]init];
            NSDictionary *dct=[fbLoginObject fbLoginAction:facebookId];
            NSNumber *status = [dct valueForKey:@"status_code"];
            NSString *access_tokenFBLogin=[dct valueForKey:@"access_token"];
            
            NSLog(@"status %@",status);
            if ([status isEqualToNumber:@1])
            {
                NSUserDefaults *fbDefaultToken = [NSUserDefaults standardUserDefaults];
                if (fbDefaultToken)
                {
                    [fbDefaultToken setObject:access_tokenFBLogin forKey:@"fb_access_Token"];
                    
                    [fbDefaultToken synchronize];
                }
                [self performSegueWithIdentifier:@"segueLogin" sender:self];
            }
            else
            {
                [[[UIAlertView alloc]initWithTitle:@"please enter facebook id " message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
                
            }
            
            
            
        }
        
    }
    
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 //  NSString *firstName = user.first_name;
                 //   NSLog(@"User details =%@",user);
                 //   NSLog(@"User details =%@",firstName);
                 //  NSLog(@"User details =%@",facebookId);
                 //  NSLog(@"Facebook id  %@",facebookId);
                 //  NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
                 //  NSLog(@"Photo url id  %@",imageUrl);
             }
         }];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"createAccountSegue"])
    {
        if(fbSignUP==YES)
        {
            createProfileViewController *signuiObj=(createProfileViewController*)[segue destinationViewController];
            signuiObj.fbSignupStatus=YES;
            signuiObj.otherSignUPstatus=NO;
            
        }
        else if(otherSignUP==YES)
        {
            createProfileViewController *signuiObj=(createProfileViewController*)[segue destinationViewController];
            signuiObj.otherSignUPstatus=YES;
            signuiObj.fbSignupStatus=NO;
            
        }
        
    }
    else if([[segue identifier]isEqualToString:@"segueLogin"])
    {
        if(fbLogin==YES)
        {
            UITabBarController *tabar=segue.destinationViewController;
            UINavigationController *navc =[tabar.viewControllers objectAtIndex:1];
            forumViewController *loginObject=[navc.viewControllers objectAtIndex:0];
            loginObject.fbLoginStaus=YES;
            loginObject.otherLoginStatus=NO;
            
            [tabar setSelectedIndex:1];
            
            
        }
        else if (otherlogin==YES)
        {
            UITabBarController *tabar=segue.destinationViewController;
            UINavigationController *navc =[tabar.viewControllers objectAtIndex:1];
            forumViewController *loginObject=[navc.viewControllers objectAtIndex:0];
            
            loginObject.otherLoginStatus=YES;
            loginObject.fbLoginStaus=NO;
            
            [tabar setSelectedIndex:1];
            
            
        }
        
    }
}


@end
