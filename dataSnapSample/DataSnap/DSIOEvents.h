//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DSIOEvents : NSObject
+ (NSArray *)getBeaconEventKeys;
+ (NSArray *)getPlaceEventKeys ;
+ (NSArray *)getGlobalPositionEventKeys  ;
+ (NSArray *)getCommunicationEventKeys;
+ (NSArray *)getGeofenceEventKeys;

@end