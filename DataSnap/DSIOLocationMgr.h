//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface DSIOLocationMgr : NSObject <CLLocationManagerDelegate>

/**
 * Set the accuracy of the location manager.
 */
- (void)setLocationAccuracyBestDistanceFilterNone;
- (NSArray *)getLocation;
- (NSMutableDictionary *)getGeoPosition;

@end
