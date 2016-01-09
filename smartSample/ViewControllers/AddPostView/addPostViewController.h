//
//  addPostViewController.h
//  
//
//  Created by Leela Electronics on 30/12/15.
//
//

#import <UIKit/UIKit.h>

@interface addPostViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
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
@property (weak, nonatomic) IBOutlet UISwitch *switchIcon;
@property (weak, nonatomic) IBOutlet UITableView *addPostSubjectTable;
@property (weak, nonatomic) IBOutlet UILabel *notifyHeadLabel;
@property (weak, nonatomic) IBOutlet UIButton *postButtonOulet;


@property(nonatomic,retain)NSString *notificaionStatus;
@property(nonatomic,retain)NSArray *subjectsArray;



- (IBAction)didTapOnCameraButton:(UIButton *)sender;
- (IBAction)didTapOnAttachPhotoButton:(UIButton *)sender;
- (IBAction)didTapOnDiscussionbutton:(UIButton *)sender;
- (IBAction)didTapOnNotificationSwitch:(UISwitch *)sender;
- (IBAction)didTapOnPostButton:(UIButton *)sender;
- (IBAction)didTapOnImageShowButton:(UIButton *)sender;
- (IBAction)didTapOnCloseButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *cellSubject;
@property (strong, nonatomic) IBOutlet UITableViewCell *postSubjectCell;

@end
