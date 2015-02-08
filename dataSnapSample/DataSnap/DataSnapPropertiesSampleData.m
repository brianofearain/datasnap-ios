//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import "DataSnapPropertiesSampleData.h"
#import "DataSnapProperties.h"


@implementation DataSnapPropertiesSampleData


+ (NSArray *) getBeaconSampleValues{
    return @[@"SHDG-28AHD",
             @"12ble_uuid",
             @"123ble_vendor_uuid",
             @"2345ble_vendor_id",
             @"987Front Entrance 1",
             @"14.34",
             @"12.56",
             @"false",
             @"2014-08-22 14:48:02 +0000",
             @{@"coordinates" : @"32.89545949009762, -117.19463284827117"},
             @"Private",
             @"50",
             @"68.32",
             @"HardwaretypeoftheBeacon",
             @"sports, women",
             @"womens, golf, shoes",
];}


+ (NSArray *)getBeaconSightingEventSampleValues {
    return @[@"beacon_sighting",
            @"12RhnUtmtXnT1UHQHClAcP",
            @"567hnUtmtXnT1UHQHClAcP",
            [self getBeaconSampleData]];
}

+ (NSMutableDictionary *) getBeaconSampleData{
    NSArray *beaconSampleValues =  [self getBeaconSampleValues] ;
    NSArray *beaconKeys =  [DataSnapProperties getBeaconProperties] ;
    NSMutableDictionary *beacon = [NSMutableDictionary dictionaryWithObjects:beaconSampleValues
                                                           forKeys:beaconKeys];
    return beacon;
}

+ (NSMutableDictionary *) getSampleBeaconSightingEvent{
    NSArray *beaconSightingSampleValues =  [self getBeaconSightingEventSampleValues] ;
    NSArray *beaconSightingEventKeys =  [DataSnapProperties getBeaconSightingEventKeys] ;
    NSMutableDictionary *beaconSighting = [NSMutableDictionary dictionaryWithObjects:beaconSightingSampleValues
                                                                     forKeys:beaconSightingEventKeys];
    return beaconSighting;
}


@end