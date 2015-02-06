#import "GlobalUtilities.h"
#import "DataSnapLocation.h"
#import "DataSnapClient.h"
#import "DataSnapEventQueue.h"
#import "DataSnapRequest.h"
#import <objc/runtime.h>

static DataSnapClient *__sharedInstance = nil;
const int eventQueueSize = 5;
static NSString *__organizationID;
static NSString *__projectID;
static BOOL loggingEnabled = NO;

@implementation NSMutableDictionary (AddNotNil)

- (void)addNotNilEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if (otherDictionary) {
        [self addEntriesFromDictionary:otherDictionary];
    }
}

@end

@interface DataSnapClient ()

/**
Private properties and methods
*/
// DataSnapEventQueue instance
@property DataSnapEventQueue *eventQueue;
@property DataSnapRequest *requestHandler;

// create a config object for logging and stuff
// Check if queue is full
- (void)checkQueue;

@end

@implementation DataSnapClient

+ (void)setupWithOrgAndProjIDs:(NSString *)organizationID projectId:(NSString *)projectID APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret {
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] initWithOrgandProjIDs:organizationID projectId:(NSString *) projectID APIKey:APIKey APISecret:APISecret];
    });
}

- (id)initWithOrgandProjIDs:(NSString *)organizationID projectId:(NSString *)projectID APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret {
    if (self = [self init]) {
        __organizationID = organizationID;
        __projectID = projectID;
        NSData *authData = [[NSString stringWithFormat:@"%@:%@", APIKey, APISecret] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authString = [authData base64EncodedStringWithOptions:0];
        self.eventQueue = [[DataSnapEventQueue alloc] initWithSize:eventQueueSize];
        self.requestHandler = [[DataSnapRequest alloc] initWithURL:@"https://api-events.datasnap.io/v1.0/events" authString:authString];
    }
    return self;
}

- (void)flushEvents {
    [self.eventQueue flushQueue];
}

- (void)genericEvent:(NSMutableDictionary *)eventDetails {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[GlobalUtilities getUserAndDataSnapDictionaryWithOrgAndProj:__organizationID projId:__projectID]];
    [eventDetails addEntriesFromDictionary:eventData];
    [self.eventQueue recordEvent:eventDetails];
    [self checkQueue];
}

- (void)beaconSightingEvent:(NSMutableDictionary *)eventDetails {
    [self eventHandler:eventDetails];
}

- (void)beaconDepartEvent:(NSMutableDictionary *)eventDetails {
    [self eventHandler:eventDetails];
}

- (void)geofenceArriveEvent:(NSMutableDictionary *)eventDetails {
    [self eventHandler:eventDetails];

}

- (void)geofenceDepartEvent:(NSMutableDictionary *)eventDetails {
    [self eventHandler:eventDetails];

}

- (void)communicationEvent:(NSMutableDictionary *)eventDetails {
    [self eventHandler:eventDetails];
}

- (void)eventHandler:(NSMutableDictionary *)eventDetails {
    // over-instantiating here - need to just fill these objects once
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[GlobalUtilities getUserAndDataSnapDictionaryWithOrgAndProj:__organizationID projId:__projectID]];
    DataSnapLocation *locationService = [DataSnapLocation sharedInstance];
    NSMutableDictionary *global_position = [locationService getGeoPosition];
    eventData[@"global_position"] = global_position[@"global_position"];
    [eventDetails addEntriesFromDictionary:eventData];
    [self.eventQueue recordEvent:eventDetails];
    [self checkQueue];
}

+ (id)sharedClient {
    return __sharedInstance;
}

- (void)checkQueue {
    // If queue is full, send events and flush queue
    if (self.eventQueue.numberOfQueuedEvents >= self.eventQueue.queueLength) {
        DSLog(@"Queue is full. %d will be sent to service and flushed.", (int) self.eventQueue.numberOfQueuedEvents);
        [self.requestHandler sendEvents:self.eventQueue.getEvents];
        [self flushEvents];
    }
}


+ (void)disableLogging {
    loggingEnabled = NO;
}

+ (void)enableLogging {
    loggingEnabled = YES;
}

+ (BOOL)isLoggingEnabled {
    return loggingEnabled;
}


#pragma mark - DataSnapUID

+ (NSString *)getDataSnapID {


    return @"TODO: this";
}


@end

