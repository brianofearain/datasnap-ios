//
//  ViewController.m
//  gimbalDemo
//
//  Created by Mark Watson on 8/7/14.
//  Copyright (c) 2014 Datasnap.io. All rights reserved.
//

#import "ViewController.h"
#import <ContextLocation/QLPlaceEvent.h>
#import <ContextLocation/QLPlace.h>
#import <FYX/FYXTransmitter.h>
#import "DataSnapClient/Client.h"

// Get current datetime
NSString* date() {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    
    NSDate *date = [NSDate new];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
}

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Gimbal Geofence Set-up
    self.placeConnector = [[QLContextPlaceConnector alloc] init];
    self.placeConnector.delegate = self;
    
    // Gimbal Proximity Set-up
    [FYX setAppId:@"98f42ba1718bd9a783575d0be6319eac3eb34039709655a27f7f8b25feabfb61"
        appSecret:@"af1aae018b3699077dd0a29d8119d0284111ce4b3f5101db7ecd826f81afede8"
      callbackUrl:@"datasnapgimbaldemo://authcode"];
    [FYX startService:self];
    
    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    [self.visitManager start];
    
    self.localNotification = [UILocalNotification new];
    self.localNotification.timeZone = [NSTimeZone defaultTimeZone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didGetPlaceEvent:(QLPlaceEvent *)placeEvent
{
    NSString *name = placeEvent.place.name;
    NSString *message = [NSString new];
    NSString *direction = [NSString new];
    
    if (placeEvent.eventType == QLPlaceEventTypeAt) {
        message = [NSString stringWithFormat:@"Geofence Event %@: At %@", date(), name];
        direction = @"Arrived";
    }
    else if (placeEvent.eventType == QLPlaceEventTypeLeft) {
        message = [NSString stringWithFormat:@"Geofence Event %@: Left %@", date(), name];
        direction = @"Left";
    }
    
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);
    
    // Fire in 1 second
    self.localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    self.localNotification.alertBody = message;
    self.localNotification.userInfo = @{@"Event": [NSString stringWithFormat:@"Geofence %@", direction],
                                        @"Datetime": date(),
                                        @"Name": name
                                        };
    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
    
    [[DataSnapClient sharedClient] beaconEvent:placeEvent eventName:[NSString stringWithFormat:@"%@ %@", direction, name]];
}

- (void)serviceStarted
{
    // this will be invoked if the service has successfully started
    // bluetooth scanning will be started at this point.
    NSLog(@"FYX Service Successfully Started");
}

- (void)startServiceFailed:(NSError *)error
{
    // this will be called if the service has failed to start
    NSLog(@"%@", error);
}

- (void)didArrive:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter is sighted for the first time
    NSString *message = [NSString stringWithFormat:@"Proximity Event: Arrived to %@", visit.transmitter.name];
    
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);
    
    // Fire in 1 second
    self.localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    self.localNotification.alertBody = message;
    self.localNotification.userInfo = @{@"Event": [NSString stringWithFormat:@"Arrived to %@", visit.transmitter.name],
                                        @"Datetime": date(),
                                        @"name": visit.transmitter.name.description
                                        };
    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
    
    [[DataSnapClient sharedClient] beaconEvent:visit];
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    // this will be invoked when an authorized transmitter is sighted during an on-going visit
    if((NSInteger)round(visit.dwellTime) == 60) {
        [[DataSnapClient sharedClient] beaconEvent:visit eventName:@"One minute dwell time"];
    }
    
}

- (void)didDepart:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter has not been sighted for some time
    NSString *message = [NSString stringWithFormat:@"Proximity Event: Left %@\nDwell Time %f", visit.transmitter.name, visit.dwellTime];
    
    DeviceLog(@"%@\n", message);
    
    // Fire in 1 second
    self.localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    self.localNotification.alertBody = message;
    self.localNotification.userInfo = @{@"Event": [NSString stringWithFormat:@"Left %@", visit.transmitter.name],
                                        @"Datetime": date(),
                                        @"name": visit.transmitter.name.description
                                        };
    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
    
    [[DataSnapClient sharedClient] beaconEvent:visit];
}

@end


