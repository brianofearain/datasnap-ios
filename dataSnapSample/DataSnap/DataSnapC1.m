#import "DataSnapC1.h"
#import "GlobalUtilities.h"
#import "DataSnapLocation.h"
#import <objc/runtime.h>


@implementation NSMutableDictionary (AddNotNil)

- (void)addNotNilEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if(otherDictionary) {
        [self addEntriesFromDictionary:otherDictionary];
    }
}

@end

@implementation DataSnapC1

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

+ (NSDictionary *)locationEvent:(NSObject *)obj details:(NSDictionary *)details org:(NSString *)orgID{ return @{}; }

// map dictionaries keys using withWith:map
+ (NSMutableDictionary *)map:(NSDictionary *)dictionary withMap:(NSDictionary *)map {
    
    NSMutableDictionary *mapped = [[NSMutableDictionary alloc] initWithDictionary:dictionary];

    for (NSString *key in map) {
        if ( map[key] ) {
           
            mapped[map[key]] = mapped[key];
            if(key != map[key]){
                [mapped removeObjectForKey:key];   
            }
        }
    }
    
    return mapped;
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
    dataDict[@"custom"] = [NSMutableDictionary new];
    dataDict[@"custom2"] = [NSMutableDictionary new];
    
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([[self getDataSnapDeviceKeys] containsObject:key]) {
            dataDict[@"datasnap"][@"device"][key] = data[key];
        } else if ([[self getUserIdentificationKeys] containsObject:key]) {
            dataDict[@"user"][@"id"][key] = data[key];
        } else {
            dataDict[@"custom"][key] = data[key];
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

