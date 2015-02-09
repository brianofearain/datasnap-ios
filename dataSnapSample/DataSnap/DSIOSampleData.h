//
// Created by Brian Feran on 2/8/15.
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
+ (NSArray *) getGeofenceSampleValues;
+ (NSMutableDictionary *) getGeofenceSampleData;

@end