//
//  addPostViewController.m
//  
//
//  Created by Leela Electronics on 30/12/15.
//
//

#import "addPostViewController.h"
#import "ChangesImageViewController.h"

@interface addPostViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, imagesChangeDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UILabel * placeHolderLabel;
}
@end

@implementation addPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    visualEffectView.alpha = 0.5;
//    
//    visualEffectView.frame = self.view.bounds;
//    [self.view addSubview:visualEffectView];
    
//    UIGraphicsBeginImageContext(self.view.bounds.size);
//    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImage* imageOfUnderlyingView = image;
//    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:20
//                                                             tintColor:[UIColor colorWithWhite:1.0 alpha:0.2]
//                                                 saturationDeltaFactor:1.3
//                                                             maskImage:nil];
//    self.view.backgroundColor = [UIColor clearColor];
//    UIImageView* backView = [[UIImageView alloc] initWithFrame:self.view.frame];
//    backView.image = imageOfUnderlyingView;
//    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//    [self.view addSubview:backView];
    
    
    
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


#pragma mark - UIButton Actions

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
}

- (IBAction)didTapOnNotificationSwitch:(UISwitch *)sender
{
}

- (IBAction)didTapOnPostButton:(UIButton *)sender
{
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
