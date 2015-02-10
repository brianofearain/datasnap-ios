//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

@interface DSIOClient : NSObject

+ (void)setupWithOrgAndProjIDs:(NSString *)organizationID projectId:(NSString *)projectID APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret;

/**
Event Handlers
*/
- (void)flushEvents;
- (void)genericEvent:(NSMutableDictionary *)eventDetails;
- (void)geofenceEvent:(NSMutableDictionary *)eventDetails;
- (void)beaconEvent:(NSMutableDictionary *)eventDetails;
- (void)eventHandler:(NSMutableDictionary *)eventDetails;
- (void)globalPositionEvent:(NSMutableDictionary *)eventDetails;
- (void)placeEvent:(NSMutableDictionary *)eventDetails;
- (void)communicationEvent:(NSMutableDictionary *)eventDetails;
- (void)campaignEvent:(NSMutableDictionary *)eventDetails;

/**
Enable/disable logging.
*/
+ (void)enableLogging;
+ (void)disableLogging;
+ (BOOL)isLoggingEnabled;

+ (id)sharedClient;

@end

/**
DSLog macro
*/
#define DSLog(message, ...)if([DSIOClient isLoggingEnabled]) NSLog(message, ##__VA_ARGS__)