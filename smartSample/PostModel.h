//
//  PostModel.h
//  smartSample
//
//  Created by Leela Electronics on 1/2/16.
//  Copyright © 2016 Leela Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostModel : NSObject

-(NSDictionary*)recentPost:(NSString*)access_token;

-(NSDictionary*)topPost:(NSString*)access_token;

-(NSDictionary*)viewPost:(NSString*)access_token;


@end
