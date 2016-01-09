//
//  UIImage+Blurr.h
//  Tell
//
//  Created by Soumya Shine on 6/10/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Blurr)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
+ (UIImage *)convertViewToImage: (UIView*) view;

@end
