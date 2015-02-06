#import "DataSnapC1.h"
#import "GlobalUtilities.h"
#import "DataSnapLocation.h"
#import "DataSnapClient.h"
#import "DataSnapEventQueue.h"
#import "DataSnapRequest.h"
#import <objc/runtime.h>

static DataSnapClient *__sharedInstance = nil;
static NSMutableDictionary *__registeredIntegrationClasses = nil;
const int eventQueueSize = 5;
static NSString *__organizationID;
static NSString *__projectID;
static BOOL loggingEnabled = NO;

@implementation NSMutableDictionary (AddNotNil)

- (void)addNotNilEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if(otherDictionary) {
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

// Check if queue is full
- (void)checkQueue;

@end


@implementation DataSnapClient

+ (void)addIDFA:(NSString *)idfa {
    [GlobalUtilities addIDFA:idfa];
}

+ (void)setupWithOrgAndProjIDs:(NSString *)organizationID projectId:(NSString *)projectID APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] initWithOrgandProjIDs:organizationID projectId:(NSString *)projectID  APIKey:APIKey APISecret:APISecret];
    });
}

- (id)initWithOrgandProjIDs:(NSString *)organizationID projectId:(NSString *)projectID APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret{
    if(self = [self init]) {
        __organizationID = organizationID;
        __projectID= projectID;
        NSData *authData = [[NSString stringWithFormat:@"%@:%@", APIKey, APISecret] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authString = [authData base64EncodedStringWithOptions:0];
        self.eventQueue = [[DataSnapEventQueue alloc] initWithSize:eventQueueSize];
        self.requestHandler = [[DataSnapRequest alloc] initWithURL:@"https://api-events.datasnap.io/v1.0/events" authString:authString];
    }
    return self;
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

- (void)flushEvents {
    [self.eventQueue flushQueue];
}

-(NSArray *)getEventQueue {
    return [self.eventQueue getEvents];
}


- (void)datasnapEvent:(NSDictionary *)userDetails communicationDetails:(NSDictionary *)communicationDetails campaignDetails:(NSDictionary *)campaignDetails
      geofenceDetails:(NSDictionary *)geofenceDetails globalpositionDetails:(NSDictionary *)globalpositionDetails placeDetails:(NSDictionary *)placeDetails
          beaconDetails:(NSDictionary *)beaconDetails{
    
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[DataSnapC1 getUserAndDataSnapDictionaryWithOrgAndProj:__organizationID projId:__projectID]];
    
    // allow user to overwrite anything that we set by default.
    // These keys and the data structures underneath should match this specification: http://docs.datasnapio.apiary.io/
    
    if (geofenceDetails) eventData[@"geo_fence"] = geofenceDetails;
    if (placeDetails) eventData[@"place"] = placeDetails;
    if (communicationDetails) eventData[@"communication"] = communicationDetails;
    if (campaignDetails) eventData[@"campaign"] = campaignDetails;
    if (globalpositionDetails) eventData[@"global_position"] = globalpositionDetails;
    if (beaconDetails) eventData[@"beacon"] = beaconDetails;
    [self.eventQueue recordEvent:eventData];
}

- (void)genericEvent:(NSMutableDictionary *)eventDetails {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[DataSnapC1 getUserAndDataSnapDictionaryWithOrgAndProj:__organizationID projId:__projectID]];

    [eventDetails addEntriesFromDictionary:eventData];
    [self.eventQueue recordEvent:eventDetails];
    [self checkQueue];
}

- (void)beaconSightingEvent:(NSMutableDictionary *)eventDetails {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[DataSnapC1 getUserAndDataSnapDictionaryWithOrgAndProj:__organizationID projId:__projectID]];

    DataSnapLocation * locationService = [DataSnapLocation sharedInstance];
    NSMutableDictionary * global_position =  [locationService getGeoPosition];
    eventData[@"global_position"] = global_position[@"global_position"];

    [eventDetails addEntriesFromDictionary:eventData];
    [self.eventQueue recordEvent:eventDetails];
    [self checkQueue];

}

- (void)beaconDepartEvent:(NSMutableDictionary *)eventDetails {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[DataSnapC1 getUserAndDataSnapDictionaryWithOrgAndProj:__organizationID projId:__projectID]];

    DataSnapLocation * locationService = [DataSnapLocation sharedInstance];
    NSMutableDictionary * global_position =  [locationService getGeoPosition];
    eventData[@"global_position"] = global_position[@"global_position"];

    [eventDetails addEntriesFromDictionary:eventData];
    [self.eventQueue recordEvent:eventDetails];
    [self checkQueue];

}

- (void)geofenceArriveEvent:(NSMutableDictionary *)eventDetails {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[DataSnapC1 getUserAndDataSnapDictionaryWithOrgAndProj:__organizationID projId:__projectID]];
    // eventData[@"other"] = eventDetails;

    DataSnapLocation * locationService = [DataSnapLocation sharedInstance];
    NSMutableDictionary * global_position =  [locationService getGeoPosition];
    eventData[@"global_position"] = global_position[@"global_position"];

    [eventDetails addEntriesFromDictionary:eventData];
    [self.eventQueue recordEvent:eventDetails];

    [self checkQueue];
}

 - (void)geofenceDepartEvent:(NSMutableDictionary *)eventDetails {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[DataSnapC1 getUserAndDataSnapDictionaryWithOrgAndProj:__organizationID projId:__projectID]];

     DataSnapLocation * locationService = [DataSnapLocation sharedInstance];
     NSMutableDictionary * global_position =  [locationService getGeoPosition];
     eventData[@"global_position"] = global_position[@"global_position"];

     [eventDetails addEntriesFromDictionary:eventData];
     [self.eventQueue recordEvent:eventDetails];

     [self checkQueue];
 }

- (void)communicationEvent:(NSMutableDictionary *)eventDetails {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[DataSnapC1 getUserAndDataSnapDictionaryWithOrgAndProj:__organizationID projId:__projectID]];

    DataSnapLocation * locationService = [DataSnapLocation sharedInstance];
    NSMutableDictionary * global_position =  [locationService getGeoPosition];
    eventData[@"global_position"] = global_position[@"global_position"];

    [eventDetails addEntriesFromDictionary:eventData];
    [self.eventQueue recordEvent:eventDetails];

    [self checkQueue];
}


+ (NSDictionary *)getUserAndDataSnapDictionaryWithOrgAndProj:(NSString *)orgID projId: (NSString *)projID{

    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:[GlobalUtilities getSystemData]];
    [data addNotNilEntriesFromDictionary:[GlobalUtilities getCarrierData]];
    [data addNotNilEntriesFromDictionary:[GlobalUtilities getIPAddress]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    dataDict[@"datasnap"] = [NSMutableDictionary new];
    dataDict[@"datasnap"][@"device"] = [NSMutableDictionary new];
    dataDict[@"datasnap"][@"txn_id"] = [GlobalUtilities transactionID];
//    dataDict[@"datasnap"][@"created"] = [dateFormatter stringFromDate:[NSDate new]];
    dataDict[@"datasnap"][@"created"] = [GlobalUtilities currentDate];
    dataDict[@"user"] = [NSMutableDictionary new];
    dataDict[@"user"][@"id"] = [NSMutableDictionary new];
    dataDict[@"user"][@"id"][@"datasnap_app_user_id"] = [GlobalUtilities getUUID];


    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([[self getDataSnapDeviceKeys] containsObject:key]) {
            dataDict[@"datasnap"][@"device"][key] = data[key];
        } else if ([[self getUserIdentificationKeys] containsObject:key]) {
            dataDict[@"user"][@"id"][key] = data[key];
        }
    }];

    NSDictionary *carrierData = [GlobalUtilities getCarrierData];
    [dataDict[@"datasnap"][@"device"] addNotNilEntriesFromDictionary:carrierData];
    dataDict[@"organization_ids"] = @[orgID];
    dataDict[@"project_ids"] = @[projID];

    return dataDict;
}



+ (NSArray *)getBeaconKeys {
    return @[@"identifier",
            @"ble_uuid",
            @"ble_vendor_uuid",
            @"blue_vendor_id",
            @"rssi",
            @"previous_rssi",
            @"name",
            @"coordinates",
            @"organization_ids",
            @"visibility",
            @"battery_level",
            @"hardware",
            @"categories",
            @"tags"];
}

+ (NSArray *)getUserIdentificationKeys {
    return @[@"mobile_device_bluetooth_identifier",
            @"mobile_device_ios_idfa",
            @"mobile_device_ios_openidfa",
            @"mobile_device_ios_idfv",
            @"mobile_device_ios_udid",
            @"datasnap_uuid",
            @"web_domain_userid",
            @"web_cookie",
            @"domain_sessionid",
            @"web_network_userid",
            @"web_user_fingerprint",
            @"web_analytics_company_z_cookie",
            @"global_distinct_id",
            @"global_user_ipaddress",
            @"mobile_device_fingerprint",
            @"facebook_uid",
            @"mobile_device_google_advertising_id",
            @"mobile_device_google_google_advertising_id_opt_in"];
}

+ (NSArray *)getDataSnapDeviceKeys {
    return @[@"user_agent",
            @"ip_address",
            @"platform",
            @"os_version",
            @"model",
            @"manufacturer",
            @"name",
            @"vendor_id"];
}


+ (id)sharedClient {
    return __sharedInstance;
}

- (void)checkQueue {
    // If queue is full, send events and flush queue
    if(self.eventQueue.numberOfQueuedEvents >= self.eventQueue.queueLength) {
        DSLog(@"Queue is full. %d will be sent to service and flushed.", (int) self.eventQueue.numberOfQueuedEvents);
        [self.requestHandler sendEvents:self.eventQueue.getEvents];
        [self flushEvents];
    }
}


+ (NSDictionary *)registeredIntegrations {
    return [__registeredIntegrationClasses copy];
}

+ (void)registerIntegration:(id)integration withIdentifier:(NSString *)name {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __registeredIntegrationClasses = [[NSMutableDictionary alloc] init];
    });
    
    __registeredIntegrationClasses[name]= integration;
    
}

#pragma mark - DataSnapUID

+ (NSString *)getDataSnapID {

    
    return @"TODO: this";
}



@end

