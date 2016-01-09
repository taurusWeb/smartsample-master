

#import "commonClass.h"

@implementation commonClass
{
    NSDictionary*submitDictionary;
    
}
+ (NSArray*)get:(NSString*)url_path
{

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    urlRequest.URL = [NSURL URLWithString:url_path];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    NSHTTPURLResponse *response = nil;
    NSError *error ;
    NSData *returnData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSArray * dataArray = [[NSArray alloc]init];
    if (!(returnData == nil))
    {
        NSError *error = nil;
        dataArray = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        
        if (error != nil)
        {
            NSLog(@"Error parsing JSON.");
        }
        else
        {
            NSLog(@"Array: %@", dataArray);
        }
    }
    return dataArray;
}
-(NSDictionary*)post:(NSString*)url_path
{
    return submitDictionary;
}
@end
