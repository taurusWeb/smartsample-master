//
//  ChangesImageViewController.h
//  
//
//  Created by Leela Electronics on 31/12/15.
//
//

#import <UIKit/UIKit.h>

@protocol imagesChangeDelegate <NSObject>

- (void) getImage: (UIImage *)image;

@end

@interface ChangesImageViewController : UIViewController


@property (nonatomic, assign)id<imagesChangeDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (nonatomic, strong) UIImage * changeImage;

- (IBAction)didTapOnCloseButton:(UIButton *)sender;
- (IBAction)didTapOnRemoveButton:(UIButton *)sender;
- (IBAction)didTapOnChangeButton:(UIButton *)sender;

@end
