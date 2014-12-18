#import "DataSnapRequest.h"
#import "DataSnapClient.h"
#import "OfflineEventStore.h"

@interface DataSnapRequest ()

@property NSString *url;
@property NSString *authString;
@property OfflineEventStore *eventStore;

@end

@implementation DataSnapRequest

-(id)initWithURL:(NSString *)url authString:(NSString *)authString{
    if(self = [super init]) {
        self.url = url;
        self.authString = authString;
    }
    return self;
}

- (void)sendEventsOfflineEventStore:(OfflineEventStore *)offlineEventStore {
    self.eventStore = offlineEventStore;
    [self prepareAndDispatch];
}

- (void)prepareData:(NSData **)jsonData andEventIds:(NSMutableDictionary **)eventIds {
    // set up the request dictionary we'll send out.
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    // create a structure that will hold corresponding ids of all the events
    NSMutableDictionary *eventIdDict = [NSMutableDictionary dictionary];
    // get data for the API request we'll make
    NSMutableDictionary *events = [[self eventStore] getEvents];
    NSError *error = nil;
    for (NSString *coll in events) {
        NSDictionary *collEvents = [events objectForKey:coll];
        // create a separate array for event data so our dictionary serializes properly
        NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
        for (NSNumber *eid in collEvents) {
            NSData *ev = [collEvents objectForKey:eid];
            NSDictionary *eventDict = [NSJSONSerialization JSONObjectWithData:ev
                                                                      options:0
                                                                        error:&error];
            if (error) {
                NSLog(@"An error occurred when deserializing a saved event: %@", [error localizedDescription]);
                continue;
            }
            // add it to the array of events
            [eventsArray addObject:eventDict];
            if ([eventIdDict objectForKey:coll] == nil) {
                [eventIdDict setObject: [NSMutableArray array] forKey: coll];
            }
            [[eventIdDict objectForKey:coll] addObject: eid];
        }
        // add the array of events to the request. send empty array instead of column name..
        [requestDict setObject:eventsArray forKey:@""];
        NSData *data = [NSJSONSerialization dataWithJSONObject:eventsArray options:0 error:&error];
        if (error) {
            NSLog(@"An error occurred when serializing the final request data back to JSON: %@",
                    [error localizedDescription]);
            // can't do much here.
            return;
        }
        *jsonData = data;
        *eventIds = eventIdDict;
    }
    if ([DataSnapClient isLoggingEnabled]) {
        NSLog(@"Uploading following events to Datasnap: %@", requestDict);
    }
}


- (void)prepareAndDispatch
{
        NSData *data = nil;
        NSMutableDictionary *eventIds = nil;
    [self prepareData:&data andEventIds:&eventIds];
        if ([data length] > 0) {
            NSURLResponse *response = nil;
            NSError *error = nil;
           [self sendEvents:data];
        }
}

- (void)sendEvents:(NSData *)data {

    NSString* json = [NSString stringWithUTF8String:[data bytes]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat: @"Basic %@", self.authString] forHTTPHeaderField:@"Authorization"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *res = nil;
    NSError *err = nil;
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&res error:&err];
    NSInteger responseCode = [res statusCode];
    if((responseCode/100) != 2){
        NSLog(@"Error sending request to %@. Response code: %d.\n", urlRequest.URL, (int) responseCode);
        if(err){
            NSLog(@"%@\n", err.description);
            // to DB here...
            // put in a DB size check function....
        }
    }
    else {
        NSLog(@"Request successfully sent to %@.\nStatus code: %d.\nData Sent: %@.\n", urlRequest.URL, (int) responseCode, json);
    }
}

@end
