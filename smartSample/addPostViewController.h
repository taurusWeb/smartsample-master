//
//  addPostViewController.h
//  
//
//  Created by Leela Electronics on 30/12/15.
//
//

#import <UIKit/UIKit.h>

@interface addPostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *scrollBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *textBackgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *attachPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *imageShowButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageShowImageView;
@property (weak, nonatomic) IBOutlet UILabel *discussionTypeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *postScrollView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

- (IBAction)didTapOnCameraButton:(UIButton *)sender;
- (IBAction)didTapOnAttachPhotoButton:(UIButton *)sender;
- (IBAction)didTapOnDiscussionbutton:(UIButton *)sender;
- (IBAction)didTapOnNotificationSwitch:(UISwitch *)sender;
- (IBAction)didTapOnPostButton:(UIButton *)sender;
- (IBAction)didTapOnImageShowButton:(UIButton *)sender;
- (IBAction)didTapOnCloseButton:(UIButton *)sender;

@end
