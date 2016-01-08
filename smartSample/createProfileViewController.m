

#import "createProfileViewController.h"
#import "searchSchoolViewController.h"
#import "searchViewController.h"
#import "AppDelegate.h"
#import "SignUPModel.h"
#import <util.h>

@interface createProfileViewController () 

@end

@implementation createProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(_fbSignupStatus==YES)
    {
        NSString *fb_image;
        
        NSUserDefaults *fbDefault = [NSUserDefaults standardUserDefaults];

        if (fbDefault)
        {
          _userNameTexdtField.text= (NSString*)[fbDefault objectForKey:@"user_name"];
            fb_image = (NSString*)[fbDefault objectForKey:@"user_image"];
            NSURL *imageUrl=[NSURL URLWithString:fb_image];
            self.userProfileImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            
            self.profileButton.hidden=YES;
        }
    }
    else if (_otherSignUPstatus==YES)
    {
     
        self.userprofileBorderImageView.hidden=YES;
        self.profileEditButton.hidden=YES;
        
    }
    
    self.userProfileImageView.layer.cornerRadius = 39;
    self.userProfileImageView.clipsToBounds = YES;
    NSAttributedString *userNamePlaceholder = [[NSAttributedString alloc] initWithString:@"username" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.subjectTextField.leftView = paddingView;
    self.subjectTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.userNameTexdtField.attributedPlaceholder = userNamePlaceholder;
    
     NSAttributedString *namePlaceholder = [[NSAttributedString alloc] initWithString:@"name (optional)" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:(103.0f/255.0f) green:(205.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0]}];
    self.nameTextField.attributedPlaceholder = namePlaceholder;
    
    NSAttributedString *schoolPlaceholder = [[NSAttributedString alloc] initWithString:@"school" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:(103.0f/255.0f) green:(205.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0]}];
    self.schoolTextField.attributedPlaceholder = schoolPlaceholder;
    
    NSAttributedString *subjectslaceholder = [[NSAttributedString alloc] initWithString:@"subjects" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:(103.0f/255.0f) green:(205.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0]}];
    self.subjectTextField.attributedPlaceholder = subjectslaceholder;
    self.subjectTagsView.tagsBackgroundColor = [UIColor colorWithRed:(103.0f/255.0f) green:(205.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0];
    self.subjectTagsView.tagsDeleteButtonColor = [UIColor whiteColor];
    self.subjectTagsView.tagsTextColor = [UIColor whiteColor];
    self.subjectTagsView.mode = TLTagsControlModeList;
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"subjects"]count])
    {
        [self.subjectTagsView addTags:[[NSUserDefaults standardUserDefaults]objectForKey:@"subjects"]];
        
        

        
        self.subjectTextField.placeholder = @"";
        
    }
    
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"school"])
    {
        self.schoolTextField.text =  [[NSUserDefaults standardUserDefaults]valueForKey:@"school"];
        
        
    }
    
    [self.subjectTagsView reloadTagSubviews];

    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOntapGesture:)];
    [self.view addGestureRecognizer:gesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.createProfileScrollView.contentInset = contentInsets;
    self.createProfileScrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.createProfileScrollView.contentInset = contentInsets;
    self.createProfileScrollView.scrollIndicatorInsets = contentInsets;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.schoolTextField)
    {
         [self performSegueWithIdentifier:@"SearchSchool" sender:self.subjectTextField];
        return  NO;
    }
    else if(textField == self.subjectTextField)
    {
        [self performSegueWithIdentifier:@"SearchSubjects" sender:self.subjectTextField];
        return NO;
    }
   
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == self.userNameTexdtField)
    {
        SignUPModel *userNameCheking=[[SignUPModel alloc]init];
        NSDictionary *dct=[userNameCheking userChecking:_userNameTexdtField.text];
        NSNumber *status = [dct valueForKey:@"status_code"];
        if ([status isEqualToNumber:@0])
        {
            self.usernameCheckImageView.image = [UIImage imageNamed:@"checkMark"];
        }
        else
        {
            self.usernameCheckImageView.image = [UIImage imageNamed:@"shapeUserNot"];
        }
       
        
    }
    return  YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchSubjects"])
    {
        searchViewController *viewController = (searchViewController *)[segue destinationViewController];
        viewController.delegate = self;
    }
    
    else if([segue.identifier isEqualToString:@"SearchSchool"])
    {
        searchSchoolViewController *viewController = (searchSchoolViewController *)[segue destinationViewController];
        viewController.delegate = self;
    }
    
}

#pragma  mark - SchoolDelegate

- (void) getSchool:(NSArray *)array
{
    if([array count])
    {
        self.schoolTextField.text = [array valueForKey:@"school_name"];
        

    }
    else
    {
        self.schoolTextField.text = @"";
    }
}

#pragma mark - SubjectDelegate

- (void) getSubjects: (NSArray *)array
{
    [self.subjectTagsView addTags:[array valueForKey:@"topic_title"]];
    [self.subjectTagsView reloadTagSubviews];
    if([array count])
    {
        self.subjectTextField.placeholder = @"";
    }
    else
    {
        NSAttributedString *subjectslaceholder = [[NSAttributedString alloc] initWithString:@"subjects" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:(103.0f/255.0f) green:(205.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0]}];
        self.subjectTextField.attributedPlaceholder = subjectslaceholder;
    }
    
}

- (IBAction)didTapOnProfileEditButton:(UIButton *)sender
{
    
    UIAlertController *imageAlert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
      imageAlert.view.backgroundColor = [UIColor clearColor];
    
    
    UIAlertAction *cameraSelection=[UIAlertAction actionWithTitle:@"camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
   
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
    }];
    
    UIAlertAction *gallerySelction=[UIAlertAction actionWithTitle:@"gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:nil
         ];
        
    }];
    UIAlertAction *removeImage=[UIAlertAction actionWithTitle:@"remove" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.userProfileImageView.image=[UIImage imageNamed:@"iconCamera"];
        self.profileEditButton.hidden=YES;
        self.userprofileBorderImageView.hidden=YES;

        
    }];
    
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [imageAlert addAction:cameraSelection];
    [imageAlert addAction:gallerySelction];
    [imageAlert addAction:removeImage];
    [imageAlert addAction:cancel];


    [self presentViewController:imageAlert animated:YES completion:nil];
  
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //self.imageData=nil;
    
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.userProfileImageView.image = chosenImage ;
    
    
    CGSize newSize=CGSizeMake(80, 80);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [chosenImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   
    self.imageData = UIImagePNGRepresentation(newImage);

    
    self.userprofileBorderImageView.hidden=NO;
    self.profileEditButton.hidden=NO;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)didTapOnProfileButton:(UIButton *)sender
{
    UIAlertController *imageAlert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    imageAlert.view.backgroundColor = [UIColor clearColor];

    
    UIAlertAction *cameraSelection=[UIAlertAction actionWithTitle:@"camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        picker.delegate = self;
        [self presentViewController:picker
                           animated:YES
                         completion:nil
         ];
        
    }];
    
    UIAlertAction *gallerySelction=[UIAlertAction actionWithTitle:@"gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:nil
         ];
        
    }];
    
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:nil
         ];
        
    }];
    
 // UIAlertAction *removeImage=[UIAlertAction actionWithTitle:@"REmove" style:UIAlertActionStyleDefault handler:nil];

    [imageAlert addAction:cameraSelection];
    [imageAlert addAction:gallerySelction];
    [imageAlert addAction:cancel];


    [self presentViewController:imageAlert animated:YES completion:nil];

    
}

- (IBAction)didTapOndoneButton:(UIButton *)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    
    [self.view endEditing:YES];
        
    NSUserDefaults *signupDefault = [NSUserDefaults standardUserDefaults];
    NSString *signUpUserName;
    NSString *signupPassword;
    if (signupDefault)
    {
        signUpUserName = [signupDefault objectForKey:@"email_address"];
        signupPassword = [signupDefault objectForKey:@"pasword"];
        
    }
    if(_fbSignupStatus==YES)
    {
        
        NSUserDefaults *fbDefault = [NSUserDefaults standardUserDefaults];
        NSString *userName;
        NSString *fb_id;
        NSString *fb_image;
        if (fbDefault)
        {
            userName = [fbDefault objectForKey:@"user_name"];
            fb_id = [fbDefault objectForKey:@"user_fbId"];
            fb_image =[fbDefault objectForKey:@"user_image"];
            
        }
        
        
        
        NSString *sch_id=[[[NSUserDefaults standardUserDefaults]objectForKey:@"school"]valueForKey:@"school_id"];
        
        NSArray *subject_ids=[[[NSUserDefaults standardUserDefaults]objectForKey:@"subjects"] valueForKey:@"topic_id"];
        

        SignUPModel *fbCreate=[[SignUPModel alloc]init];
        NSDictionary *fbDict=[fbCreate fbSignUP:fb_id fb_picture:fb_image fb_name:userName name:_nameTextField.text school:sch_id subject:subject_ids];
        NSNumber *status = [fbDict valueForKey:@"status_code"];
        
        if ([status isEqualToNumber:@1])
        {
            SignUPModel *fbLoginObject=[[SignUPModel alloc]init];
            NSDictionary *dct=[fbLoginObject fbLoginAction:fb_id];
            NSNumber *status = [dct valueForKey:@"status_code"];
            NSString *access_tokenFBLogin=[dct valueForKey:@"access_token"];
           
            if ([status isEqualToNumber:@1])
            {
                [self performSegueWithIdentifier:@"createToMainPageSegue" sender:self];

                
            }

        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"error for creating account...!" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];

        }
         
        
    }
    else if (_otherSignUPstatus==YES)
    {
    

        
        
        NSString *sch_id=[[[NSUserDefaults standardUserDefaults]objectForKey:@"school"]valueForKey:@"school_id"];
   
        NSArray *subject_ids=[[[NSUserDefaults standardUserDefaults]objectForKey:@"subjects"] valueForKey:@"topic_id"];
        
        
    SignUPModel *createccountObject=[[SignUPModel alloc]init];
    
  //   NSDictionary *dct=[createccountObject createAccount:signUpUserName password:signupPassword username:_userNameTexdtField.text name:_nameTextField.text school:_schoolTextField.text subject:self.subjectTagsView.tags profilePic:imgdata];
        
               NSDictionary *dct=[createccountObject createAccount:signUpUserName password:signupPassword username:_userNameTexdtField.text name:_nameTextField.text school:sch_id subject:subject_ids profilePic:_imageData];

    NSNumber *status = [dct valueForKey:@"status_code"];
        
   
    if ([status isEqualToNumber:@1])
    {
        SignUPModel *loginModelObject=[[SignUPModel alloc]init];
        NSDictionary *dctLogin=[loginModelObject doLogin:signUpUserName password:signupPassword];
        
       
         
        NSNumber *status = [dctLogin valueForKey:@"status_code"];
      //   NSString *access_code=[dctLogin valueForKey:@"access_token"];
        
        if ([status isEqualToNumber:@1])
        {
            [self performSegueWithIdentifier:@"createToMainPageSegue" sender:self];
        }
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"email_address"] || [[NSUserDefaults standardUserDefaults]objectForKey:@"pasword"] )
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"email_address"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"pasword"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }

    }
    else
    {
        
        [[[UIAlertView alloc]initWithTitle:@"error !" message:@"for creating account" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
    }
  
    }

}


- (void)didTapOntapGesture:(UIGestureRecognizer *) gesture
{
    [self.view endEditing:YES];
}


@end
