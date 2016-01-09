

#import <UIKit/UIKit.h>

@interface forumViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *forumTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property(nonatomic,retain)NSString *user_accessToken;
@property(nonatomic)BOOL fbLoginStaus;
@property(nonatomic)BOOL otherLoginStatus;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) NSMutableArray * dataShowArray;


- (IBAction)didTapOnAddButton:(UIButton *)sender;

@end
