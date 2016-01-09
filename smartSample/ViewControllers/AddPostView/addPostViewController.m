

#import "addPostViewController.h"
#import "ChangesImageViewController.h"
#import "UIImage+Blurr.h"
#import "PostModel.h"

@interface addPostViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, imagesChangeDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UILabel * placeHolderLabel;
}
@end

@implementation addPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.backgroundImageView.image  = [UIImage convertViewToImage:self.view];
    
    self.backgroundImageView.image = [self.backgroundImageView.image  blurredImageWithRadius:3.5   iterations:1 tintColor:[UIColor blackColor]];
    
    self.postButton.alpha = 0.5;
    
    NSAttributedString *namePlaceholder = [[NSAttributedString alloc] initWithString:@"Post Title" attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor]}];
    self.titleTextField.attributedPlaceholder = namePlaceholder;
    
    self.textBackgroundImageView.layer.borderWidth = 1.5;
    self.textBackgroundImageView.layer.borderColor = [UIColor colorWithRed:(103.0f/255.0f) green:(205.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0].CGColor;
    self.textBackgroundImageView.layer.cornerRadius = 10;
    
    self.scrollBackgroundView.layer.cornerRadius = 10;
    
    self.imageShowImageView.hidden = YES;
    self.imageShowButton.hidden = YES;

    self.imageShowImageView.layer.cornerRadius = 5;
    self.imageShowImageView.layer.borderColor = [UIColor colorWithRed:(103.0f/255.0f) green:(205.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0].CGColor;
    self.imageShowImageView.layer.borderWidth = 1.5;
    self.imageShowImageView.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0,self.descriptionTextView.frame.size.width - 10.0, 34.0)];
    placeHolderLabel.text = @"Enter your post...";
    placeHolderLabel.font = [UIFont fontWithName:@"GothamRounded-Medium" size:14];
    placeHolderLabel.backgroundColor = [UIColor clearColor];
    placeHolderLabel.textColor  = [UIColor lightGrayColor];
    [self.descriptionTextView addSubview:placeHolderLabel];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOntapGesture:)];
    [self.view addGestureRecognizer:gesture];
    
    
    _subjectsArray=[[NSArray alloc]initWithObjects:@"MathematicsHL",@"MathematicsSL",@"Science SL", nil];
    _addPostSubjectTable.hidden=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.postScrollView.contentInset = contentInsets;
    self.postScrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.postScrollView.contentInset = contentInsets;
    self.postScrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - UITextField DelegateMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(!([searchStr isEqualToString:@""]) && !([searchStr  isEqualToString: @"\n"]))
    {
        self.postButton.alpha = 1;
    }
    else if([self.descriptionTextView.text isEqualToString:@""] && self.imageShowImageView.image == nil )
    {
         self.postButton.alpha = 0.5;
    }
    return  YES;
}


#pragma mark - UITextView DelegateMethods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString * searchStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if(!([searchStr isEqualToString:@""]) && !([searchStr  isEqualToString: @"\n"]))
    {
        self.postButton.alpha = 1;
    }
    else if([self.titleTextField.text isEqualToString:@""] && self.imageShowImageView.image == nil )
    {
        self.postButton.alpha = 0.5;
    }

    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![theTextView hasText]) {
        placeHolderLabel.hidden = NO;
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(![textView hasText]) {
        placeHolderLabel.hidden = NO;
    }
    else{
        placeHolderLabel.hidden = YES;
    }  
}

#pragma mark - UIIMagePicker DelegateMethods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageShowImageView.image = chosenImage ;
    self.imageShowImageView.hidden = NO;
    self.imageShowButton.hidden = NO;
    self.attachPhotoButton.hidden = YES;
    self.cameraButton.hidden = YES;
    self.postButton.alpha = 1;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - UITableview DelegateMethods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [_subjectsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
    static NSString *cellidentifier=@"addPostCellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if(cell==nil)
    {
        [[NSBundle mainBundle]loadNibNamed:@"addPostCell" owner:self options:nil];
        cell=_postSubjectCell;
        cell.accessoryView = nil;
        
    }
    
    _cellSubject.text=[self.subjectsArray objectAtIndex:indexPath.row];
    
    return cell;

    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
 //  _discussionTypeLabel.text=self.subjectsArray[indexPath.row];
    
    NSLog(@"selected");
    
    _addPostSubjectTable.hidden=YES;
    
    _postButtonOulet.hidden=NO;
    _notifyHeadLabel.hidden=NO;
    _switchIcon.hidden=NO;

  
}

#pragma mark - UIButton Actions

- (IBAction)switchIcon:(id)sender {
}

- (IBAction)didTapOnCameraButton:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (IBAction)didTapOnAttachPhotoButton:(UIButton *)sender
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (IBAction)didTapOnDiscussionbutton:(UIButton *)sender
{
    
    _addPostSubjectTable.hidden=NO;
    
    _postButtonOulet.hidden=YES;
    _notifyHeadLabel.hidden=YES;
    _switchIcon.hidden=YES;
    
    
}

- (IBAction)didTapOnNotificationSwitch:(UISwitch *)sender
{
    if(self.switchIcon.on)
    {
        self.notificaionStatus=@"1";
    }
    else
    {
        self.notificaionStatus=@"0";
    }
}

- (IBAction)didTapOnPostButton:(UIButton *)sender
{
   
    CGSize newSize=CGSizeMake(60, 60);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [_imageShowImageView.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *post_imageData= UIImagePNGRepresentation(newImage);
    
    //post_imageData
    //self.notificaionStatus
    //_titleTextField.text
   // _descriptionTextView.text
    //subjectss
    
 
    
    PostModel *postObj=[[PostModel alloc]init];
    
    NSDictionary *postDictionary=[postObj add_post:_titleTextField.text post_content:_descriptionTextView.text post_image:post_imageData subject:@"1"];
    
    
    NSNumber *status = [postDictionary valueForKey:@"status_code"];
    
    if ([status isEqualToNumber:@1])
    {
        [[[UIAlertView alloc]initWithTitle:@"add post successfully  ...!" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"Error for adding post  ...!" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
    }
}

- (IBAction)didTapOnImageShowButton:(UIButton *)sender
{
    
    ChangesImageViewController * changeView = [[ChangesImageViewController alloc]initWithNibName:@"ChangesImageViewController" bundle:nil];
    UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:changeView];
    navigation.modalPresentationStyle   = UIModalPresentationCustom;
    changeView.changeImage = self.imageShowImageView.image;
    changeView.delegate = self;
    [self presentViewController:navigation animated:YES completion:nil];
}

- (IBAction)didTapOnCloseButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ChangeViewController DelegateMethods

- (void) getImage:(UIImage *)image
{
    if(image == nil)
    {
        self.imageShowImageView.hidden = YES;
        self.imageShowButton.hidden = YES;
        self.attachPhotoButton.hidden = NO;
        self.cameraButton.hidden = NO;
        if([self.titleTextField.text isEqualToString:@""] && [self.descriptionTextView.text isEqualToString:@""])
        {
            self.postButton.alpha = 0.5;
        }
    }
    
    self.imageShowImageView.image = image;
}

- (void)didTapOntapGesture:(UIGestureRecognizer *) gesture
{
    [self.view endEditing:YES];
}
@end
