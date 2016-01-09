//
//  searchViewController.h
//  smartSample
//
//  Created by Leela Electronics on 23/12/15.
//  Copyright (c) 2015 Leela Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

@protocol subjectDelegate <NSObject>

- (void) getSubjects: (NSArray *)array;


@end

@interface searchViewController : UIViewController 


@property (nonatomic, assign)id<subjectDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIImageView *emptyTableImageView;
@property (weak, nonatomic) IBOutlet UIButton *searchDoneButton;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet TLTagsControl *tagsView;

@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, strong) NSMutableArray * dataShowArray, * tagsArray;
- (IBAction)didTapOnSearchDoneButton:(UIButton *)sender;

@end
