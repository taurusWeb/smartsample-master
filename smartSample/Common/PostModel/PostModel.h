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

-(NSDictionary*)add_post:(NSString*)post_title post_content:(NSString*)post_content post_image:(NSData*)post_img subject:(NSString*)subj;


@end
