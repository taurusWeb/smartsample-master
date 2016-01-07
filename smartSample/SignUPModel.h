

#import <Foundation/Foundation.h>

@interface SignUPModel : NSObject

-(NSDictionary *)doLogin:(NSString*)username password:(NSString*)psw;

-(NSDictionary *)signupUserCheking:(NSString*)username;

-(NSDictionary *)createAccount:(NSString*)email password:(NSString*)psw username:(NSString*)usrName name:(NSString *)name school:(NSString *)school subject:(NSArray *)sub profilePic:(NSData*)pic;


-(NSDictionary*)userChecking:(NSString*)username;

-(NSDictionary*)forgotpassword:(NSString*)email;

-(NSDictionary *)fbSignUP:(NSString*)fb_id fb_picture:(NSString*)fb_pic fb_name:(NSString*)fb_name name:(NSString*)name school:(NSString*)school subject:(NSArray*)subject;

-(NSDictionary*)fbIDCheking:(NSString*)fb_id;

-(NSDictionary*)fbLoginAction:(NSString*)fbid;

@end
