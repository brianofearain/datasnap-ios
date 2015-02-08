#import <CoreLocation/CoreLocation.h>

@interface DataSnapClient : NSObject

+ (void)setupWithOrgAndProjIDs:(NSString *)organizationID projectId:(NSString *)projectID APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret;

extern const char MyConstantKey;

/**
Enable/disable logging.
*/
+ (void)enableLogging;
+ (void)disableLogging;
+ (BOOL)isLoggingEnabled;
- (void)flushEvents;
- (void)genericEvent:(NSMutableDictionary *)eventDetails;
- (void)geofenceArriveEvent:(NSMutableDictionary *)eventDetails;
- (void)beaconSightingEvent:(NSMutableDictionary *)eventDetails;
- (void)eventHandler:(NSMutableDictionary *)eventDetails;

- (NSMutableDictionary *)getUserInfo ;
- (NSMutableDictionary *)getDataSnap;

+ (id)sharedClient;

@end

/**
DSLog macro
*/
#define DSLog(message, ...)if([DataSnapClient isLoggingEnabled]) NSLog(message, ##__VA_ARGS__)