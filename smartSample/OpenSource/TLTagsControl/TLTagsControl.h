//
//  TLTagsControl.h
//  TagsInputSample
//
//  Created by Антон Кузнецов on 11.02.15.
//  Copyright (c) 2015 TheLightPrjg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLTagsControl;

@protocol TLTagsControlDelegate <NSObject>

@optional
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index;
- (void)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacedString:(NSString *)string;
- (void)removedTag: (NSString *) string;

@end

typedef NS_ENUM(NSUInteger, TLTagsControlMode) {
    TLTagsControlModeEdit,
    TLTagsControlModeList,
};

@interface TLTagsControl : UIScrollView

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) UIColor *tagsBackgroundColor;
@property (nonatomic, strong) UIColor *tagsTextColor;
@property (nonatomic, strong) UIColor *tagsDeleteButtonColor;
@property (nonatomic, strong) NSString *tagPlaceholder;
@property (nonatomic) TLTagsControlMode mode;

@property (assign, nonatomic) id<TLTagsControlDelegate> tapDelegate;

- (id)initWithFrame:(CGRect)frame andTags:(NSArray *)tags withTagsControlMode:(TLTagsControlMode)mode;
- (id) addTags: (NSArray *) tags;
- (void) deleteTag: (NSString *) string;
- (void)addTag:(NSString *)tag;
- (void)reloadTagSubviews;

@end