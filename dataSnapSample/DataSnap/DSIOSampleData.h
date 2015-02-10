//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DSIOSampleData : NSObject

// Beacon
+ (NSArray *) getBeaconSampleValues;
+ (NSMutableDictionary *) getBeaconSampleData;

// Beacon Event
+ (NSArray *)getBeaconEventSampleValues ;
+ (NSMutableDictionary *) getSampleBeaconEvent;

// Geofence
+ (NSArray *) getGeofenceEventSampleValues;
+ (NSMutableDictionary *) getGeofenceEventSampleData;

// Place
+ (NSArray *) getPlaceEventSampleValues;
+ (NSMutableDictionary *) getPlaceEventSampleData;

// GlobalPosition
+ (NSArray *) getGlobalPositionEventSampleValues;
+ (NSMutableDictionary *) getGlobalPositionEventSampleData;

// Communication
+ (NSArray *) getCommunicationEventSampleValues;
+ (NSMutableDictionary *) getCommunicationEventSampleData;

@end