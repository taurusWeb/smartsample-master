

#import "SignUPModel.h"
@import MobileCoreServices;    // only needed in iOS

@implementation SignUPModel
{
    NSDictionary*submitDictionary;
    
}

//user login
-(NSDictionary *)doLogin:(NSString*)username password:(NSString*)psw
{
    
    NSDictionary *payloadDict =[NSDictionary dictionaryWithObjectsAndKeys:username,@"username",psw,@"password", nil];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/login/send"];
    urlRequest.URL = [NSURL URLWithString:urlString];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:NULL];
    [urlRequest setHTTPBody:jsonData];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSLog(@"urlString: %@\npayloadDict: %@", urlString, payloadDict);
    
    NSLog(@"return data %@",returnData);
    if (!(returnData == nil))
    {
        submitDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if([[submitDictionary objectForKey:@"status_code"]isEqualToNumber:@1])
        {
            return submitDictionary;
        }
        else
        {
            NSLog(@"no data found.... ");
        }
    }
    return submitDictionary;
}

// user name cheking ath signup page

-(NSDictionary *)signupUserCheking:(NSString*)username;
{
    
    NSDictionary *payloadDict =[NSDictionary dictionaryWithObjectsAndKeys:username,@"email", nil];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/login/checkemail"];
    urlRequest.URL = [NSURL URLWithString:urlString];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:NULL];
    [urlRequest setHTTPBody:jsonData];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSLog(@"urlString: %@\npayloadDict: %@", urlString, payloadDict);
    
    NSLog(@"return data %@",returnData);
    if (!(returnData == nil))
        
    {
        submitDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if([[submitDictionary objectForKey:@"status_code"]isEqualToNumber:@0])
        {
            return submitDictionary;
        }
        else
        {
            NSLog(@"no data found.... ");
        }
        
    }
    return submitDictionary;
    
}


// create account- saving user account details

-(NSDictionary *)createAccount :(NSString*)email password:(NSString*)psw username:(NSString*)usrName name:(NSString *)name school:(NSString *)school subject:(NSArray *)sub profilePic:(NSData*)pic
{
    
    NSString * resultSubjects = [sub componentsJoinedByString:@","];
    
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:email,@"email",psw,@"password",usrName,@"username",name,@"name",school,@"userschool",resultSubjects,@"usersubjects",nil];
       
    
    NSString *boundary = [self generateBoundaryString];
    NSURL *url=[[NSURL alloc]initWithString:@"http://50.87.153.156/~smartibapp/dev/api.php/login/register"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params paths:pic fieldName:@"fieldname"];
    
    request.HTTPBody = httpBody;
   
    
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!(returnData == nil))
    {
        NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
        submitDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
    }
    
    /*
  
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (connectionError) {
            NSLog(@"error = %@", connectionError);
            return;
        }
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        submitDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        
        NSLog(@"result = %@", result);
        NSLog(@"result Dictionary = %@", submitDictionary);
        
        
        
    }];
   
    */
    
    return  submitDictionary;
  
    
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

// cheking  with user name is existing or not
-(NSDictionary*)userChecking:(NSString*)username
{
    NSDictionary *payloadDict =[NSDictionary dictionaryWithObjectsAndKeys:username,@"username", nil];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/login/checkusername"];
    urlRequest.URL = [NSURL URLWithString:urlString];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:NULL];
    [urlRequest setHTTPBody:jsonData];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSLog(@"urlString: %@\npayloadDict: %@", urlString, payloadDict);
    NSLog(@"return data %@",returnData);
    if (!(returnData == nil))
    {
        submitDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if([[submitDictionary objectForKey:@"status_code"]isEqualToNumber:@0])
        {
            return submitDictionary;
        }
        else
        {
            NSLog(@"no data found.... ");
        }
        
    }
    return submitDictionary;
    
    
}


-(NSDictionary*)forgotpassword:(NSString*)email
{
    
    NSDictionary *payloadDict =[NSDictionary dictionaryWithObjectsAndKeys:email,@"forgot_email", nil];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/login/resetpassword"];
    urlRequest.URL = [NSURL URLWithString:urlString];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:NULL];
    [urlRequest setHTTPBody:jsonData];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSLog(@"urlString: %@\npayloadDict: %@", urlString, payloadDict);
    
    NSLog(@"return data %@",returnData);
    if (!(returnData == nil))
        
    {
        submitDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if([[submitDictionary objectForKey:@"status_code"]isEqualToNumber:@1])
        {
            return submitDictionary;
        }
        else
        {
            NSLog(@"no data found.... ");
        }
        
    }
    return submitDictionary;
    
}

-(NSDictionary *)fbSignUP:(NSString*)fb_id fb_picture:(NSString*)fb_pic fb_name:(NSString*)fb_name name:(NSString*)name school:(NSString*)school subject:(NSArray*)subject
{
    
    
    NSString * resultSubjects = [subject componentsJoinedByString:@","];
    
    NSDictionary *payloadDict =[NSDictionary dictionaryWithObjectsAndKeys:fb_id,@"fbid",fb_pic,@"fb_profile_pic",fb_name,@"username",name,@"name",school,@"userschool",resultSubjects,@"usersubjects", nil];
    
    // usrName,@"username",name,@"name",school,@"school",sub,@"subjects",pic,@"profilePic",nil];
    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/login/register"];
    urlRequest.URL = [NSURL URLWithString:urlString];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:NULL];
    [urlRequest setHTTPBody:jsonData];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSLog(@"urlString: %@\npayloadDict: %@", urlString, payloadDict);
    
    NSLog(@"return data %@",returnData);
    if (!(returnData == nil))
        
    {
        submitDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if([[submitDictionary objectForKey:@"status_code"]isEqualToNumber:@1])
        {
            return submitDictionary;
        }
        else
        {
            NSLog(@"no data.... ");
        }
        
    }
    return submitDictionary;
}


-(NSDictionary*)fbIDCheking:(NSString*)fb_id
{
    NSDictionary *payloadDict =[NSDictionary dictionaryWithObjectsAndKeys:fb_id,@"fbid", nil];
    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/login/checkfbid"];
    urlRequest.URL = [NSURL URLWithString:urlString];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:NULL];
    [urlRequest setHTTPBody:jsonData];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSLog(@"urlString: %@\npayloadDict: %@", urlString, payloadDict);
    
    NSLog(@"return data %@",returnData);
    if (!(returnData == nil))
        
    {
        submitDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if([[submitDictionary objectForKey:@"status_code"]isEqualToNumber:@1])
        {
            return submitDictionary;
        }
        else
        {
            NSLog(@"no data found.... ");
        }
        
    }
    return submitDictionary;
}


-(NSDictionary*)fbLoginAction:(NSString*)fbid
{
    NSDictionary *payloadDict =[NSDictionary dictionaryWithObjectsAndKeys:fbid,@"fbid", nil];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://50.87.153.156/~smartibapp/dev/api.php/login/fblogin"];
    urlRequest.URL = [NSURL URLWithString:urlString];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:NULL];
    [urlRequest setHTTPBody:jsonData];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSLog(@"urlString: %@\npayloadDict: %@", urlString, payloadDict);
    
    NSLog(@"return data %@",returnData);
    if (!(returnData == nil))
    {
        submitDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if([[submitDictionary objectForKey:@"status_code"]isEqualToNumber:@1])
        {
            return submitDictionary;
        }
        else
        {
            NSLog(@"no data found.... ");
        }
    }
    return submitDictionary;
    
}



@end
