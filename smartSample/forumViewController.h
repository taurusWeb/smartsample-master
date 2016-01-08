

#import <UIKit/UIKit.h>

@interface forumViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *forumTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

- (IBAction)didTapOnAddButton:(UIButton *)sender;
@property(nonatomic,retain)NSString *user_accessToken;


@property(nonatomic)BOOL fbLoginStaus;
@property(nonatomic)BOOL otherLoginStatus;
@property(nonatomic,retain)NSArray *recentPostArray;
@property(nonatomic,retain)NSArray *recentPostArrayAuthor;
@property(nonatomic,retain)NSArray *recentPostTimeArray;

@property(nonatomic,retain)NSArray *topPostArrayAuthor;
@property(nonatomic,retain)NSArray *topPostArrayTime;



@property(nonatomic,retain)NSArray *topPostAray;



@end
