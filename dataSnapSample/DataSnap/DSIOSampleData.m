//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import "DSIOSampleData.h"
#import "DSIOProperties.h"
#import "DSIOEvents.h"


@implementation DSIOSampleData

#pragma mark - Beacon Event Sample Data

// removed tags and categories for now
+ (NSMutableDictionary *) getBeaconPropertySampleData{
    NSMutableDictionary *beacon = [[NSMutableDictionary alloc] init];
    beacon = @{@"iconUrl": @"https:\/\/proximity.test.com\/assets\/fallback\/default_icon.png",
            @"last_update_time":@"2015-02-09 23:13:56 +0000",
            @"battery_level": @2,
            @"name": @"Test Mobile Beacon",
            @"rssi": @-40,
            @"temperature": @75,
            @"hardware": @"Test",
            @"dwell_time": @9
};

    return beacon;
}

+ (NSMutableDictionary *) getDataSnapSampleValues {
    NSMutableDictionary *dataSnap = [[NSMutableDictionary alloc] init];
    dataSnap = @{@"created" : @"2015-02-09T16:55:47.546-0800", @"device" : [self getDeviceSampleValues],
            @"txn_id" : @"126ad448837cd7922cc6d5537c49743f723bfc1"};
     return  dataSnap;
}

+ (NSMutableDictionary *)getDeviceSampleValues {
    NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
    device = @{@"network_code" : @"651",
            @"vendor_id" : @"63A7355F-5AF2-4E20-BE55-C3E80D0305B1",
            @"manufacturer" : @"Apple",
            @"iso_country_code": @"us",
            @"name" : @"3s46b5341fe54492e57f2500468686243dee0af5",
            @"os_version" : @"8.1",
            @"carrier_name": @"Verizon",
            @"platform" : @"iPhone OS",
            @"country_code": @"342",
            @"ip_address" : @"127.1.1.1",
            @"model" : @"iPhone" };
    return device;
}

+ (NSMutableDictionary *)getUserIdSampleData {
    NSMutableDictionary *userId = [[NSMutableDictionary alloc] init];
    userId = @{@"id" : @{@"global_distinct_id" : @"836BBCBB-E552-4369-818E-C931D80CC051",
            @"datasnap_app_user_id":  @"836BBCBB-E552-4369-818E-C931D80CC051" }};
    return userId;
};

+ (NSMutableDictionary *) getSampleBeaconSightingEvent{
    NSArray *beaconSightingSampleValues =  [self getBeaconEventSampleValues] ;
    NSArray *beaconSightingEventKeys = [DSIOProperties getBeaconSightingEventProperties] ;
    NSLog(@"here6");

    NSMutableDictionary *beaconSighting = [NSMutableDictionary dictionaryWithObjects:beaconSightingSampleValues
                                                                     forKeys:beaconSightingEventKeys];
    return beaconSighting;
}

+ (NSArray *)getBeaconEventSampleValues {
    return @[@"beacon_sighting",
            [self getBeaconPropertySampleData],
            [self getUserIdSampleData],
            [self getDataSnapSampleValues]];
}

#pragma mark - Geofence Event Sample Data

+ (NSArray *)getGeofenceEventSampleValues {
    return @[@"geofence_arrive",
            [self getGeofenceSampleData],
            [self getPlaceSampleData],
            [self getUserIdSampleData]];
}

+ (NSMutableDictionary *)getGeofenceSampleData {
    NSMutableDictionary *geoFence = @{@"time": @"2014-08-22 14:48:02 +0000",
            @"identifier": @"SHDG-28AHD",
        @"name": @"Geofence-123",
        @"geofence_circle": @{@"radius" : @"12",
                    @"location" : @{@"coordinates" : @"32.89545949009762, -117.19463284827117"}}};
                    return geoFence;
            }

+ (NSMutableDictionary *)getPlaceSampleData {
    NSMutableDictionary *place = @{@"time": @"2014-08-22 14:48:02 +0000",
            @"id": @"placeid",
            @"name": @"Mission District",
            @"places": @{@"placeid" : @"placeid2",
                    @"placeid" :  @"placeid3"},
            @"beacons": @{@"beaconid" : @"beaconid2",
                    @"beaconid" :  @"beaconid3"},
            @"last_place": @"placeid-3"};
    return place;
}


+ (NSMutableDictionary *) getSampleGeofenceEvent{
    NSArray *geofenceSampleValues =  [self getGeofenceEventSampleValues] ;
    NSArray *geofenceEventKeys = [DSIOEvents getGeofenceEventKeys] ;
    NSLog(@"here7");

    NSMutableDictionary *geoEvent = [NSMutableDictionary dictionaryWithObjects:geofenceSampleValues
                                                                             forKeys:geofenceEventKeys];
    return geoEvent;
}

#pragma mark - Place Event Sample Data

+ (NSArray *)getPlaceEventSampleValues {
    return @[@"place_arrive",
            [self getUserIdSampleData],
            [self getGlobalPositionSampleData],
            [self getDataSnapSampleValues]];
}

+ (NSMutableDictionary *)getGlobalPositionSampleData {
    NSMutableDictionary *globalPosition = @{@"location" :
            @{@"coordinates" : @"32.89545949009762, -117.19463284827117"},
            @"course" : @-1, @"accuracy" : @"10", @"altitude" : @"1.607983827590942", @"speed" : @"-1"};
    return globalPosition;
}

+ (NSMutableDictionary *) getSamplePlaceEvent{
    NSArray *placeSampleValues =  [self getPlaceEventSampleValues] ;
    NSArray *placeEventKeys = [DSIOEvents getPlaceEventKeys] ;
    NSLog(@"here8");

    NSMutableDictionary *place = [NSMutableDictionary dictionaryWithObjects:placeSampleValues
                                                                       forKeys:placeEventKeys];
    return place;
}


#pragma mark - Global Position Event Sample Data

+ (NSArray *)getGlobalPositionEventSampleValues {
    return @[@"place_arrive",
            [self getUserIdSampleData],
            [self getGlobalPositionSampleData],
            [self getDataSnapSampleValues]];
}

+ (NSMutableDictionary *) getSampleGlobalPositionEvent{
    NSArray *globalPositionSampleValues =  [self getGlobalPositionEventSampleValues] ;
    NSArray *globalPositionEventKeys = [DSIOEvents getGlobalPositionEventKeys] ;
    NSLog(@"here9");

    NSMutableDictionary *globalPosition = [NSMutableDictionary dictionaryWithObjects:globalPositionSampleValues
                                                                             forKeys:globalPositionEventKeys];
    return globalPosition;
}

#pragma mark - Communication Event Sample Data

+ (NSArray *)getCommunicationEventSampleValues {
    return @[@"communication_delivered",
            [self getUserIdSampleData],
            [self getSampleCommunicationData],
            [self getSampleCampaignData]];
}

+ (NSMutableDictionary *) getSampleCommunicationData{
    NSMutableDictionary *communication = @{@"description" : @"mydescription" ,
        @"id" : @"commid",
        @"communication_vendor_id" : @"airpush123",
        @"name" : @"10% offPushnotification",
        @"type": @{@"id" : @"typeid",
                @"name" :  @"PushNotificaion"},
        @"content": @{@"text" : @"get10%off!",
                @"description" :  @"get10%offifyougotothe",
                @"image": @"http: //appl.com/image.gif",
                @"html": @"<p>Hithere!!get10%offnow!!</p>",
                @"url": @"http: //www.apple.com"},

    };
    return communication;}


+ (NSMutableDictionary *) getSampleCampaignData{
    NSMutableDictionary *campaign = @{@"id" : @"campaignid" ,
            @"name": @"camapign10%offshoes",
            @"communication_vendor_id" : @"airpush123",
            @"name" : @"10% offPushnotification",
            @"type": @{@"id" : @"typeid",
                    @"name" :  @"PushNotificaion"},
            @"communication_ids": @[@"commid1", @"commid2"]
    };
    return campaign;}

+ (NSMutableDictionary *) getSampleCommunicationEvent{
    NSArray *communicationSampleValues =  [self getCommunicationEventSampleValues] ;
    NSArray *communicationEventKeys = [DSIOEvents getCommunicationEventKeys] ;
    NSLog(@"here10");

    NSMutableDictionary *globalPosition = [NSMutableDictionary dictionaryWithObjects:communicationSampleValues
                                                                             forKeys:communicationEventKeys];
    return globalPosition;
}




@end