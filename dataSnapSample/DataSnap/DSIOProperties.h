#import <Foundation/Foundation.h>

@interface DSIOProperties : NSObject

// Serialize object into JSON string
+ (NSString *)jsonStringFromObject:(NSObject *)obj;
+ (NSString *)jsonStringFromObject:(NSObject *)obj prettyPrint:(BOOL)pretty;

// System Data
+ (NSDictionary *)getSystemData;
+ (NSDictionary *)getIPAddress;
+ (NSDictionary *)getCarrierData;
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

//every network address associated with the device
+ (NSDictionary *)getIPAddresses;
+ (NSString *)currentDate;
+ (NSString *)transactionID;
+ (NSString *)getUUID;

// this function should be removed as it has been split into the two beneath
+ (NSDictionary *)getUserAndDataSnapDictionaryWithOrgAndProj:(NSString *)orgID projId:(NSString *)projID;
+ (NSDictionary *)getUserInfo:(NSString *)orgID projId:(NSString *)projID;
+ (NSDictionary *)getDataSnap:(NSString *)orgID projId:(NSString *)projID;

+ (NSMutableDictionary *)map:(NSDictionary *)dictionary withMap:(NSDictionary *)map;
+ (NSDictionary *)dictionaryRepresentation:(NSObject *)obj;
+ (void)nsDateToNSString:(NSMutableDictionary *)dict;
+ (void)addIDFA:(NSString *)idfa;


+ (NSArray *)getBeaconProperties;
+ (NSArray *)getBeaconSightingEventKeys;


@end

