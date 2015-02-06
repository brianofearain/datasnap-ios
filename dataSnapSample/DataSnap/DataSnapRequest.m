#import "DataSnapRequest.h"
#import "GlobalUtilities.h"

@interface DataSnapRequest ()

@property NSString *url;
@property NSString *authString;

@end

@implementation DataSnapRequest

- (id)initWithURL:(NSString *)url authString:(NSString *)authString {
    if (self = [super init]) {
        self.url = url;
        self.authString = authString;
    }
    return self;
}

- (void)sendEvents:(NSObject *)events {

    NSString *json = [GlobalUtilities jsonStringFromObject:events];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"Basic %@", self.authString] forHTTPHeaderField:@"Authorization"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];

    NSHTTPURLResponse *res = nil;
    NSError *err = nil;
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&res error:&err];
    NSInteger responseCode = [res statusCode];

    if ((responseCode / 100) != 2) {
        NSLog(@"Error sending request to %@. Response code: %d.\n", urlRequest.URL, (int) responseCode, json);
        if (err) {
            NSLog(@"%@\n", err.description, json);
        }
    }
    else {
        NSLog(@"Request successfully sent to %@.\nStatus code: %d.\nData Sent: %@.\n", urlRequest.URL, (int) responseCode, json);
    }
}

@end
