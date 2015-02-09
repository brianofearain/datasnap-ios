//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import "DSIOSampleData.h"
#import "DSIOProperties.h"


@implementation DSIOSampleData


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


+ (NSArray *)getBeaconEventSampleValues {
    return @[@"beacon_sighting",
            @[@"12RhnUtmtXnT1UHQHClAcP"],
            @[@"567hnUtmtXnT1UHQHClAcP"],
            [self getBeaconSampleData],
            [self getDataSnapSampleData],
            [self getUserSampleData]];
}


+ (NSMutableDictionary *) getDataSnapSampleData{
    NSArray *dataSnapSampleValues =  [self getDataSnapSampleValues] ;
    NSArray *dataSnapKeys = [DSIOProperties getDataSnapKeys] ;
    NSMutableDictionary *beacon = [NSMutableDictionary dictionaryWithObjects:dataSnapSampleValues
                                                                     forKeys:dataSnapKeys];
    return beacon;
}



+ (NSArray *)getDataSnapSampleValues {
    return @[@"2014-08-22 14:48:02 +0000",
            [self getDeviceSampleValues]];
    }
+ (NSArray *)getDeviceSampleValues {
    return @[@"Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
            @"127.1.1.1",
            @"ios",
            @"7.0",
            @"iPhone5",
            @"Apple",
            @"hashed device name",
            @"63A7355F-5AF2-4E20-BE55-C3E80D0305B1",
            @"Verizon",
            @"1",
            @"327"];
}


+ (NSMutableDictionary *) getUserSampleData{
    NSArray *userSampleValues =  [self getUserSampleValues] ;
    NSArray *userKeys = [DSIOProperties getUserKeys] ;
    NSMutableDictionary *beacon = [NSMutableDictionary dictionaryWithObjects:userSampleValues
                                                                     forKeys:userKeys];
    return beacon;
}

+ (NSArray *)getUserSampleValues {
    return @[@"womens,golf,shoes",
            [self getUserIdSampleValues],
            [self getAudienceSampleValues],
            [self getUserPropertiesSampleValues]];
}

 + (NSArray *)getUserIdSampleValues {
    return @[@"128 bit string",
    @"092384",
    @"09238dd4",
    @"092344",
    @"123",
    @"datasnap_uuid",
    @"12-QW",
    @"foo",
    @"fqr9fgwer8vb9",
    @"billybob",
    @"web_user_fingerprint",
    @"web_analytics_company_z_cookie",
    @"userid1234",
    @"user_ipaddress",
    @"2da076c7ad28740c0b2a9b7fa6077c4f",
    @"2234433",
    @"googid",
    @"true"];
    }


+ (NSArray *)getAudienceSampleValues {
    return @[@"Education: [College],Age:[18-24],Ethnicity: [Caucasian],Kids: [NoKids],Gender:[Male],Interests: "
            "[Gettingfromheretothere,Biking,Automotive,Automotive.Cars],Income: [$30-60k"
    ];
}

+ (NSArray *)getUserPropertiesSampleValues {
    return @[@"user_type: VIP, user_spend: high,engagement_time: Greaterthan30minutes"];
}

+ (NSMutableDictionary *) getBeaconSampleData{
    NSArray *beaconSampleValues =  [self getBeaconSampleValues] ;
    NSArray *beaconKeys =  [DSIOProperties getBeaconProperties] ;
    NSMutableDictionary *beacon = [NSMutableDictionary dictionaryWithObjects:beaconSampleValues
                                                           forKeys:beaconKeys];
    return beacon;
}

+ (NSMutableDictionary *) getSampleBeaconSightingEvent{
    NSArray *beaconSightingSampleValues =  [self getBeaconEventSampleValues] ;
    NSArray *beaconSightingEventKeys = [DSIOProperties getBeaconSightingEventProperties] ;
    NSMutableDictionary *beaconSighting = [NSMutableDictionary dictionaryWithObjects:beaconSightingSampleValues
                                                                     forKeys:beaconSightingEventKeys];
    return beaconSighting;
}


@end