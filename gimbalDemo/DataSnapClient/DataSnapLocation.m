//
//  DataSnapLocation.m
//  DataSnapClient
//
//  Created by Mark Watson on 8/15/14.
//  Copyright (c) 2014 Datasnap.io. All rights reserved.
//

#import "DataSnapLocation.h"

@implementation DataSnapLocation

static DataSnapLocation *SINGLETON = nil;
static CLLocationManager *locationManager  = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[DataSnapLocation alloc] init];
}

- (id)mutableCopy
{
    return [[DataSnapLocation alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    
    locationManager = [[CLLocationManager alloc] init]; // initializing locationManager

    if ([locationManager respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [locationManager requestAlwaysAuthorization];
    }
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    [locationManager startUpdatingLocation];  //requesting location updates
    
    return self;
}


- (NSArray *)getLocation {
    NSArray *coords = @[[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude],
                        [NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude]];
    
    return coords;
}

- (NSArray *)getLocationCoordinates:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    return @[[NSString stringWithFormat:@"%@",latitude],
             [NSString stringWithFormat:@"%@",longitude]];
}

- (NSArray *)getLocationCoordinatesFromDouble:(double)latitude longitude:(double)longitude {
    return @[[NSString stringWithFormat:@"%f",latitude],
             [NSString stringWithFormat:@"%f",longitude]];
}


- (NSMutableDictionary *)getGeoPosition {
    
    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    dataDict[@"global_position"] =  [NSMutableDictionary new];
    dataDict[@"global_position"][@"altitude"] = [NSNumber numberWithDouble:locationManager.location.altitude];
    dataDict[@"global_position"][@"accuracy"] = [NSNumber numberWithDouble:locationManager.location.verticalAccuracy];
    dataDict[@"global_position"][@"course"] = [NSNumber numberWithDouble:locationManager.location.course];
    dataDict[@"global_position"][@"speed"] = [NSNumber numberWithDouble:locationManager.location.speed];
    dataDict[@"datasnap"][@"location"] = [NSMutableDictionary new];
    
    NSArray *coords = [[DataSnapLocation sharedInstance] getLocation];
    
    dataDict[@"global_position"][@"location"] = @{@"coordinates": coords};

    return dataDict;
}

@end
