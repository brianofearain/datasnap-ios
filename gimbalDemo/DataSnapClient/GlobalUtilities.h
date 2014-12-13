#import <Foundation/Foundation.h>

@interface GlobalUtilities : NSObject

// Serialize object into JSON string
+ (NSString *)jsonStringFromObject:(NSObject *)obj;
+ (NSString *)jsonStringFromObject:(NSObject *)obj prettyPrint:(BOOL)pretty;

+ (void)nsdateToNSString:(NSMutableDictionary *)dict;

+ (void)addIDFA:(NSString *)idfa;

// System Data
+ (NSDictionary *)getSystemData;
+ (NSDictionary *)getIPAddress;
+ (NSDictionary *)getCarrierData;

/**
 Returns a string of the device IP Address
 @param preferIPv4 BOOL preferring IPv4 over IPv6
 @return NSString of the device's IP Address
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

/**
 Returns a dictionary containing every network address associated with the device
 @return NSDictionary
 */
+ (NSDictionary *)getIPAddresses;

+ (NSString *) currentDate;

+ (NSString *) transactionID;

+ (NSString *)getUUID;

@end

