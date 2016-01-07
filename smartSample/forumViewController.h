

#import <UIKit/UIKit.h>

@interface forumViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *forumTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

- (IBAction)didTapOnAddButton:(UIButton *)sender;
@property(nonatomic,retain)NSString *user_accessToken;


@property(nonatomic)BOOL fbLoginStaus;
@property(nonatomic)BOOL otherLoginStatus;

@end
