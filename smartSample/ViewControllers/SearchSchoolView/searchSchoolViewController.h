
#import <UIKit/UIKit.h>
#import "TLTagsControl.h"



@protocol schoolDelegate <NSObject>

- (void) getSchool: (NSArray *)array;

@end

@interface searchSchoolViewController : UIViewController<TLTagsControlDelegate>

@property (nonatomic,assign)id<schoolDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *searchSchoolTextField;
@property (weak, nonatomic) IBOutlet TLTagsControl *searchTagView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *searchDoneButton;
@property (weak, nonatomic) IBOutlet UITableView *schoolTableView;
@property (nonatomic, strong) NSMutableArray * tagsArray;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;

@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) NSMutableArray * dataShowArray;
- (IBAction)didTapOnSearchDoneButton:(UIButton *)sender;

@end
