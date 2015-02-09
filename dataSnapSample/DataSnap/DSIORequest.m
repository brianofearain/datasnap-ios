#import "DSIORequest.h"
#import "DSIOProperties.h"

@interface DSIORequest ()

@property NSString *url;
@property NSString *authString;

@end

@implementation DSIORequest

- (id)initWithURL:(NSString *)url authString:(NSString *)authString {
    if (self = [super init]) {
        self.url = url;
        self.authString = authString;
    }
    return self;
}

- (void)sendEvents:(NSObject *)events {
    NSString *json = [DSIOProperties jsonStringFromObject:events];
    // pointing here for time being
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://private-98bba-datasnapio.apiary-mock.com/v1.0/events/?api_key=$E9NZuB6A91e2J03PKA2g7wx0629czel8&data=$%2520WERF%2520&redirect=$http%3A%2F%2Fwww.apple.com"]];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // [urlRequest setValue:[NSString stringWithFormat:@"Basic %@", self.authString] forHTTPHeaderField:@"Authorization"];
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
