//
//  favoritesViewController.h
//  
//
//  Created by Leela Electronics on 29/12/15.
//
//

#import <UIKit/UIKit.h>

@interface favoritesViewController : UIViewController
- (IBAction)didTapOnBackButton:(UIButton *)sender;
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) NSMutableArray * dataShowArray;

@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;

@end
