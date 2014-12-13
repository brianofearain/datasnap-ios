#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DataSnapClient : NSObject

/**
 Create a sinlge instance of a DataSnapClient for the project with a project ID
 provided by DataSnap.io
 */
+ (void)setupWithOrgAndProjIDs:(NSString *)organizationID projectId:(NSString *)projectID APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret;
/**
 Enable/disable logging.
 */
+ (void)enableLogging;
+ (void)disableLogging;
+ (BOOL)isLoggingEnabled;

+ (void)addIDFA:(NSString *)idfa;

- (void)interactionEvent:(NSDictionary *)dictionary fromTap:(NSString *)tap;
- (void)interactionEvent:(NSObject *)event;
- (void)interactionEvent:(NSObject *)event details:(NSDictionary *)details;


///**
// Enable/disable the use of location services
// */
//+ (void)enableLocation;
//+ (void)disableLocation;

/**
 Flush all events from queue
 */
- (void)flushEvents;

/**
 Return (NSArray) current event queue
 */
-(NSArray *)getEventQueue;

/**
 Record beacon event
 */
- (void)locationEvent:(NSObject *)event;
- (void)locationEvent:(NSObject *)event details:(NSDictionary *)details;

- (void)genericEvent:(NSDictionary *)eventDetails;

/**
 Return client for project
 */
+ (id)sharedClient;

/**
 Register 3rd Party Integration
 */
+ (void)registerIntegration:(id)integration withIdentifier:(NSString *)name;

+ (NSDictionary *)registeredIntegrations;

+ (NSString *)getDataSnapID;

@end

/**
 DSLog macro
 */
#define DSLog(message, ...)if([DataSnapClient isLoggingEnabled]) NSLog(message, ##__VA_ARGS__)