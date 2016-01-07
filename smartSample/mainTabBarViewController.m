

#import "mainTabBarViewController.h"

@interface mainTabBarViewController ()

@end

@implementation mainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setSelectedViewController:(UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
    
    for (UIViewController *viewController in self.viewControllers) {
        if (viewController == selectedViewController) {
            [viewController.tabBarItem setTitleTextAttributes:@{
                                                                NSFontAttributeName: [UIFont fontWithName:@"GothamRounded-Medium" size:10]
                                                                }
                                                     forState:UIControlStateNormal];
                    
        } else {
            [viewController.tabBarItem setTitleTextAttributes:@{
                                                                NSFontAttributeName: [UIFont fontWithName:@"GothamRounded-Bold" size:10],
                                                                NSForegroundColorAttributeName:[UIColor colorWithRed:0.082 green:0.157 blue:0.184 alpha:1]
                                                                }
                                                     forState:UIControlStateNormal];
            viewController.tabBarItem.image = [viewController.tabBarItem.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        }
    }
}
@end
