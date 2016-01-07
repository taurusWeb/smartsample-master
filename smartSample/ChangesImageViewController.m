//
//  ChangesImageViewController.m
//  
//
//  Created by Leela Electronics on 31/12/15.
//
//

#import "ChangesImageViewController.h"

@interface ChangesImageViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL flagValue;
    NSInteger imageValue;
}
@end

@implementation ChangesImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.displayImageView.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
    flagValue = NO;
    imageValue = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if(imageValue == 1)
    {
    self.displayImageView.image = self.changeImage;
        imageValue = 0;
    }
}

#pragma mark - UIImagePicker DelegateMethods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.displayImageView.image = chosenImage ;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    flagValue = YES;
    
}


- (IBAction)didTapOnCloseButton:(UIButton *)sender
{
    if(flagValue == YES)
    {
        [self.delegate getImage:self.displayImageView.image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapOnRemoveButton:(UIButton *)sender
{
    self.displayImageView.image  = nil;
    [self.delegate getImage:self.displayImageView.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapOnChangeButton:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
@end
