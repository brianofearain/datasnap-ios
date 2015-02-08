//
// Created by Brian Feran on 2/8/15.
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DSIOPropertiesSampleData : NSObject

// Beacon
+ (NSArray *) getBeaconSampleValues;
+ (NSMutableDictionary *) getBeaconSampleData;

// Beacon Sighting Event
+ (NSArray *)getBeaconSightingEventSampleValues ;
+ (NSMutableDictionary *) getSampleBeaconSightingEvent;

// Geofence
+ (NSArray *) getGeofenceSampleValues;
+ (NSMutableDictionary *) getGeofenceSampleData;

@end