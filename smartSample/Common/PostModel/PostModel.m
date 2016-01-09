//
//  PostModel.m
//  smartSample
//
//  Created by Leela Electronics on 1/2/16.
//  Copyright © 2016 Leela Electronics. All rights reserved.
//

#import "PostModel.h"
@import MobileCoreServices;    // only needed in iOS

@implementation PostModel
{
    NSDictionary *recentPostDict;
    NSDictionary *topPostDict;
    NSDictionary *postViewDict;
    NSDictionary *add_postDict;

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



-(NSDictionary*)add_post:(NSString*)post_title post_content:(NSString*)post_content post_image:(NSData*)post_img subject:(NSString*)subj;
{
    //keys:  posttitle, posttext, subject, notify, file
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:post_title,@"posttitle",post_content,@"posttext",post_img,@"image",subj,@"subject",@"1",@"notify",nil];
    
    NSString *boundary = [self generateBoundaryString];
    NSURL *url=[[NSURL alloc]initWithString:@"http://50.87.153.156/~smartibapp/dev/api.php/post/add?access-token=6020d56d5bc3eb3067f8ac76884313fc"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params paths:post_img fieldName:@"file"];
    
    request.HTTPBody = httpBody;
    
    
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!(returnData == nil))
    {
        NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        add_postDict = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
    }
    
    
    return  add_postDict;
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSData *)paths
                         fieldName:(NSString *)fieldName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    NSString* FileParamConstant = @"file";
    
    if (paths) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [httpBody appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:paths];
        [httpBody appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    
}


- (NSString *)mimeTypeForPath:(NSString *)path
{
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    CFRelease(UTI);
    return mimetype;
}

-(NSDictionary*)imageUpload:(NSData*)profPic
{
    
    return nil;
}


@end
