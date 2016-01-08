

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"
#import "searchViewController.h"
#import "searchSchoolViewController.h"

@interface createProfileViewController : UIViewController <UITextFieldDelegate, schoolDelegate, subjectDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userprofileBorderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTexdtField;
@property (weak, nonatomic) IBOutlet UIImageView *usernameCheckImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *schoolTextField;
@property (weak, nonatomic) IBOutlet TLTagsControl *subjectTagsView;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *createProfileScrollView;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *profileEditButton;

- (IBAction)didTapOnProfileEditButton:(UIButton *)sender;
- (IBAction)didTapOnProfileButton:(UIButton *)sender;

- (IBAction)didTapOndoneButton:(UIButton *)sender;

@property(nonatomic)BOOL otherSignUPstatus;
@property(nonatomic)BOOL fbSignupStatus;
@property(nonatomic,retain)NSData *imageData;
@end
