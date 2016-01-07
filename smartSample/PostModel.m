//
//  PostModel.m
//  smartSample
//
//  Created by Leela Electronics on 1/2/16.
//  Copyright © 2016 Leela Electronics. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel
{
    NSDictionary *recentPostDict;
    NSDictionary *topPostDict;
    NSDictionary *postViewDict;
    
}
-(NSDictionary*)recentPost:(NSString*)access_token
{
    NSDictionary *payloadDict =[NSDictionary dictionaryWithObjectsAndKeys:access_token,@"access_token", nil];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/post/recent?access_token=%@",access_token];
    urlRequest.URL = [NSURL URLWithString:urlString];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:NULL];
    [urlRequest setHTTPBody:jsonData];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
  //  NSLog(@"urlString: %@\npayloadDict: %@", urlString, payloadDict);
  //  NSLog(@"return data %@",returnData);
    
    if (!(returnData == nil))
        
    {
        recentPostDict = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
            return recentPostDict;
    }
       else
        {
            NSLog(@"no data found.... ");
        }
        

   return  recentPostDict;
}

-(NSDictionary*)topPost:(NSString*)access_token
{
    NSDictionary *payloadDict =[NSDictionary dictionaryWithObjectsAndKeys:access_token,@"access_token", nil];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/post/top?access_token=%@",access_token];
    urlRequest.URL = [NSURL URLWithString:urlString];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:NULL];
    [urlRequest setHTTPBody:jsonData];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
 //   NSLog(@"urlString: %@\npayloadDict: %@", urlString, payloadDict);
//    NSLog(@"return data %@",returnData);
    if (!(returnData == nil))
    {
        topPostDict = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        
            return topPostDict;
        }
        else
        {
            NSLog(@"no data found.... ");
        }
        
   
    return topPostDict;
    
}

-(NSDictionary*)viewPost:(NSString*)access_token
{
    NSDictionary *payloadDict =[NSDictionary dictionaryWithObjectsAndKeys:access_token,@"access_token", nil];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/post/viewpost"];
    urlRequest.URL = [NSURL URLWithString:urlString];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:NULL];
    [urlRequest setHTTPBody:jsonData];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
   // NSLog(@"urlString: %@\npayloadDict: %@", urlString, payloadDict);
  //  NSLog(@"return data %@",returnData);
    if (!(returnData == nil))
    {
        postViewDict = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
      
            return topPostDict;
        }
        else
        {
            NSLog(@"no data found.... ");
        }
    return postViewDict;
    
}

@end
