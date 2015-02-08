#import <Foundation/Foundation.h> // Apple
#import <CoreLocation/CoreLocation.h>


@interface DSIOLocationMgr : NSObject <CLLocationManagerDelegate>

/**
 * Set the accuracy of the location manager.
 */
- (void)setLocationAccuracyBestDistanceFilterNone;
- (NSArray *)getLocation;
- (NSMutableDictionary *)getGeoPosition;

@end
