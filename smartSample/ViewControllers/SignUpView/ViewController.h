//
//  ViewController.h
//  smartSample
//
//  Created by Leela Electronics on 22/12/15.
//  Copyright (c) 2015 Leela Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController<FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginMainButton;
@property (weak, nonatomic) IBOutlet UIImageView *signupDropUpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *loginDropUpImageView;
@property (weak, nonatomic) IBOutlet UIButton *createAcoountButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;
@property (weak, nonatomic) IBOutlet UIScrollView *signupScrollView;

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

- (IBAction)didTapOnSignUpButton:(UIButton *)sender;
- (IBAction)didTapOnLoginButton:(UIButton *)sender;
- (IBAction)didTapOnCreateAccountButton:(UIButton *)sender;
- (IBAction)didTapOnLoginMainButton:(UIButton *)sender;
- (IBAction)didTapOnForgotButton:(UIButton *)sender;
- (IBAction)didTapOnLoginFbMainButton:(UIButton *)sender;


@end

