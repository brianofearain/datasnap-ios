#import "GlobalUtilities.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UIKit/UIDevice.h>
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

static NSMutableDictionary *__globalData;

@implementation NSMutableDictionary (AddNotNil)

- (void)addNotNilEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if (otherDictionary) {
        [self addEntriesFromDictionary:otherDictionary];
    }
}

@end


@implementation GlobalUtilities

+ (NSString *)jsonStringFromObject:(NSObject *)obj {
    return [self jsonStringFromObject:obj prettyPrint:NO];
}

+ (NSString *)jsonStringFromObject:(NSObject *)obj prettyPrint:(BOOL)pretty {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:(NSJSONWritingOptions) (pretty ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];

    if (!jsonData) {
        NSLog(@"jsonStringFromObject: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}


+ (void)nsdateToNSString:(NSMutableDictionary *)dict {
    NSMutableDictionary *copy = [dict mutableCopy];

    for (NSString *key in dict) {
        if ([dict[key] isKindOfClass:[NSDate class]]) {
            copy[key] = [dict[key] description];
        }
    }

    [dict removeAllObjects];
    [dict addEntriesFromDictionary:copy];
}

+ (void)addIDFA:(NSString *)idfa {

    __globalData[@"mobile_device_ios_idfa"] = idfa;

}

+ (NSDictionary *)getSystemData {

    // Set global data on first call, this will not change over time
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIDevice *device = [UIDevice currentDevice];
        NSMutableDictionary *data = [NSMutableDictionary new];

        data[@"name"] = [GlobalUtilities sha1:device.name];
        data[@"platform"] = device.systemName;
        data[@"os_version"] = device.systemVersion;
        data[@"model"] = device.model;
        data[@"localized_model"] = device.localizedModel;
        data[@"vendor_id"] = [device.identifierForVendor UUIDString];
        data[@"manufacturer"] = @"Apple";

        __globalData = data;
    });

    return __globalData;
}

+ (NSDictionary *)getIPAddress {
    NSString *ipAddresses = [GlobalUtilities getIPAddress:true];
    if (ipAddresses.length) {
        return @{@"ip_address" : ipAddresses};
    }
    return NULL;
}

+ (NSDictionary *)getCarrierData {
    CTCarrier *carrier = [[CTTelephonyNetworkInfo new] subscriberCellularProvider];
    if (carrier.carrierName.length) {
        return @{@"carrier_name" : carrier.carrierName,
                @"iso_county_code" : carrier.isoCountryCode,
                @"country_code" : carrier.mobileCountryCode,
                @"network_code" : carrier.mobileNetworkCode
        };
    }
    return NULL;
}

+ (NSString *)sha1:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (CC_LONG) data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
            @[IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6] :
            @[IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4];

    NSDictionary *addresses = [self getIPAddresses];

    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        address = addresses[key];
        if (address) *stop = YES;
    }];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];

    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for (interface = interfaces; interface; interface = interface->ifa_next) {
            if (!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in *) interface->ifa_addr;
            char addrBuf[MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN)];
            if (addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if (addr->sin_family == AF_INET) {
                    if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6 *) interface->ifa_addr;
                    if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if (type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

// Get current datetime
+ (NSString *)currentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];

    NSDate *date = [NSDate new];

    return [dateFormatter stringFromDate:date];
}

+ (NSString *)transactionID {
    return [self sha1:[NSString stringWithFormat:@"%@%@", [self currentDate], [[UIDevice currentDevice] identifierForVendor]]];
}

+ (NSString *)getUUID {

    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DataSnapUUID"]) {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        [[NSUserDefaults standardUserDefaults]
                setObject:(NSString *) CFBridgingRelease(string) forKey:@"DataSnapUUID"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"DataSnapUUID"];
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

+ (NSDictionary *)locationEvent:(NSObject *)obj details:(NSDictionary *)details org:(NSString *)orgID {
    return @{};
}

// map dictionaries keys using withWith:map
+ (NSMutableDictionary *)map:(NSDictionary *)dictionary withMap:(NSDictionary *)map {

    NSMutableDictionary *mapped = [[NSMutableDictionary alloc] initWithDictionary:dictionary];

    for (NSString *key in map) {
        if (map[key]) {

            mapped[map[key]] = mapped[key];
            if (key != map[key]) {
                [mapped removeObjectForKey:key];
            }
        }
    }

    return mapped;
}

+ (NSDictionary *)getUserAndDataSnapDictionaryWithOrgAndProj:(NSString *)orgID projId:(NSString *)projID {

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


    NSLog(@"datadictionary");
    NSLog(@"My dictionary is %@", dataDict);
    return dataDict;
}

// return dictionary of an objects properties
+ (NSDictionary *)dictionaryRepresentation:(NSObject *)obj {

    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([obj class], &count);

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];

    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [obj valueForKey:key];

        // Only add to the NSDictionary if it's not nil.
        if (value)
            [dictionary setObject:value forKey:key];
    }

    return dictionary;
}


@end
