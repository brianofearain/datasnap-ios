//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//
#import "DSIOProperties.h"
#import "DSIOClient.h"
#import "DSIOEventQueue.h"
#import "DSIORequest.h"
#import "DSIOLocationMgr.h"
#import <objc/runtime.h>

static DSIOClient *__sharedInstance = nil;
const int eventQueueSize = 20;
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

@interface DSIOClient ()

@property DSIOEventQueue *eventQueue;
@property DSIORequest *requestHandler;
@property DSIOLocationMgr *locationMgr;

- (void)checkQueue;

@end

@implementation DSIOClient

#pragma mark - Init the SDK with org id, project id, apikey and apisecret

+ (void) setupWithOrgAndProjIDs:(NSString *)organizationID projectId:(NSString *)projectID APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret {
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
        self.eventQueue = [[DSIOEventQueue alloc] initWithSize:eventQueueSize];
        self.requestHandler = [[DSIORequest alloc] initWithURL:@"https://api-events.datasnap.io/v1.0/events" authString:authString];
        self.locationMgr = [[DSIOLocationMgr alloc] init];
    }
    return self;
}

#pragma mark - Event Handlers

- (void)flushEvents {
    [self.eventQueue flushQueue];
}

- (void)genericEvent:(NSMutableDictionary *)eventDetails {
    [self eventHandler:eventDetails];
}

- (void)beaconEvent:(NSMutableDictionary *)eventDetails {
    if ([eventDetails valueForKeyPath:@"beacon.identifier"] != nil)
        [self eventHandler:eventDetails];
    else {
        NSLog(@"Unable to create beacon event, beacon properties not correct");
    }
}

- (void)geofenceEvent:(NSMutableDictionary *)eventDetails {
    if ([eventDetails valueForKeyPath:@"geofence.identifier"]!= nil)
        [self eventHandler:eventDetails];
    else {
        NSLog(@"Unable to create beacon event, beacon properties not correct");
    }
}

- (void)globalPositionEvent:(NSMutableDictionary *)eventDetails {
    if ([eventDetails valueForKeyPath:@"globalPosition.location"]!= nil){
        [eventDetails addEntriesFromDictionary:[self.locationMgr getGeoPosition]];
        [self eventHandler:eventDetails];
    }
    else {
        NSLog(@"Unable to create GPS event, GPS properties not correct");
    }
}

- (void)placeEvent:(NSMutableDictionary *)eventDetails {
    if ([eventDetails valueForKeyPath:@"place.id"] != nil)
        [self eventHandler:eventDetails];
    else {
        NSLog(@"Unable to create place event, place properties not correct");
    }
}

- (void)communicationEvent:(NSMutableDictionary *)eventDetails {
    if ([eventDetails valueForKeyPath:@"communication.identifier"] != nil)
        [self eventHandler:eventDetails];
    else {
        NSLog(@"Unable to create communication event, communication properties not correct");
    }
}

- (void)eventHandler:(NSMutableDictionary *)eventDetails {
    [eventDetails addEntriesFromDictionary:@{@"organization_ids" : @[__organizationID], @"project_ids" : @[__projectID]}];
    [self.eventQueue recordEvent:eventDetails];
    [self checkQueue];
}

+ (id)sharedClient {
    return __sharedInstance;
}

- (void)checkQueue {
    if (self.eventQueue.numberOfQueuedEvents >= self.eventQueue.queueLength) {
        DSLog(@"Queue is full. %d will be sent to service and flushed.", (int) self.eventQueue.numberOfQueuedEvents);
        [self.requestHandler sendEvents:self.eventQueue.getEvents];
        [self flushEvents];
    }
}


#pragma mark - Turn on/off logging

+ (void)disableLogging {
    loggingEnabled = NO;
}

+ (void)enableLogging {
    loggingEnabled = YES;
}

+ (BOOL)isLoggingEnabled {
    return loggingEnabled;
}

@end

