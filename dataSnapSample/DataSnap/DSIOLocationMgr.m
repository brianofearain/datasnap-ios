#import "DSIOLocationMgr.h"


@interface DSIOLocationMgr ()

/**
 * Datasnap.io usage of CoreLocation
 */
@property (strong, nonatomic) CLLocationManager *locationManager;

/**
 * The timestamp of the last saved location
 */
@property (strong, nonatomic) NSDate *lastLocationTimestamp;

/**
 * Suspend location updates when not required.
 */
- (void)suspendLocationUpdates;

/**
 * Save location updates
 */
- (void)saveLocation:(NSArray *)locations;

@end


@implementation DSIOLocationMgr

- (id)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [self setLocationAccuracyBestDistanceFilterNone];
        [_locationManager requestAlwaysAuthorization];
        [_locationManager startUpdatingLocation];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setLocationAccuracyBestDistanceFilterNone {
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
}

#pragma mark - Private Methods

- (void)saveLocation:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    if (_lastLocationTimestamp == nil) {
        _lastLocationTimestamp = location.timestamp;
    } else if ([location.timestamp timeIntervalSinceDate:self.lastLocationTimestamp] >= 10) {
        // TODO: Do something with the location coördinates
        NSLog(@"%@: %f, %f, %f", location.timestamp, location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
        _lastLocationTimestamp = location.timestamp;
        [self suspendLocationUpdates];
    }
}

- (void)suspendLocationUpdates {
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    _locationManager.distanceFilter = 99999;
}

#pragma mark - getGeoLocationData

- (NSMutableDictionary *)getGeoPosition {
    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    dataDict[@"global_position"] = [NSMutableDictionary new];
    dataDict[@"global_position"][@"altitude"] = [NSNumber numberWithDouble:_locationManager.location.altitude];
    dataDict[@"global_position"][@"accuracy"] = [NSNumber numberWithDouble:_locationManager.location.verticalAccuracy];
    dataDict[@"global_position"][@"course"] = [NSNumber numberWithDouble:_locationManager.location.course];
    dataDict[@"global_position"][@"speed"] = [NSNumber numberWithDouble:_locationManager.location.speed];
    dataDict[@"datasnap"][@"location"] = [NSMutableDictionary new];
    NSArray *coords = [self getLocation];
    dataDict[@"global_position"][@"location"] = @{@"coordinates" : coords};
    return dataDict;
}


- (NSArray *)getLocation {
    NSArray *coords = @[[NSString stringWithFormat:@"%f", _locationManager.location.coordinate.latitude],
            [NSString stringWithFormat:@"%f", _locationManager.location.coordinate.longitude]];
    return coords;
}


#pragma mark - CLLocationMangerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self saveLocation:locations];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

@end
