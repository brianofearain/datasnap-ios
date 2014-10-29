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
NSString* currentDate() {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    
    NSDate *date = [NSDate new];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
}

NSString *currentTime() {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *date = [NSDate new];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
}

@interface ViewController ()

@property NSString *lastOfficeEnterTime;
@property NSString *lastGerofence;
@property NSMutableString *garsString;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.lastOfficeEnterTime = [NSString new];
    self.lastGerofence = [NSString new];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.garsString = [NSMutableString new];
    [self.garsString setString:@""];
	
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
    
    [self lunchReminder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)textFieldReturn:(id)sender {
    [self.garsString setString:self.GarsTextField.text];
    [sender resignFirstResponder];
}

- (void)didGetPlaceEvent:(QLPlaceEvent *)placeEvent
{
    // Just arrived to the office
    if ( ([placeEvent.place.name  isEqualToString:@"Datasnap Home Office"]) && (placeEvent.eventType == QLPlaceEventTypeAt) ) {
        [self localNotificationWithMessage:[NSString stringWithFormat:@"Hi - You arrived at %@ Time and I am a GeoFence", currentTime()]
                                  userInfo:@{@"Event": @"Arrive to Office Geofence",
                                             @"Datetime": currentDate(),
                                             @"Name": placeEvent.place.name}];
        self.lastOfficeEnterTime = currentTime();
    }
    
    // Peets Coffee
    if ( ([placeEvent.place.name isEqualToString:@"Peets Coffee - 4th & Harrison"]) && (placeEvent.eventType == QLPlaceEventTypeAt) ) {
        [self localNotificationWithMessage:@"Hope you're just getting coffee. NO MUFFIN FOR YOU!"
                                  userInfo:@{@"Event": @"Arrive to Peets Geofence",
                                             @"Datetime": currentDate(),
                                             @"Name": placeEvent.place.name}];
    }
    
    NSString *name = placeEvent.place.name;
    NSString *message = [NSString new];
    NSString *direction = [NSString new];
    
    if (placeEvent.eventType == QLPlaceEventTypeAt) {
        message = [NSString stringWithFormat:@"Geofence Event %@: At %@", currentDate(), name];
        direction = @"arrive";
    }
    else if (placeEvent.eventType == QLPlaceEventTypeLeft) {
        message = [NSString stringWithFormat:@"Geofence Event %@: Left %@", currentDate(), name];
        direction = @"depart";
    }
    
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);
    
    [[DataSnapClient sharedClient] locationEvent:placeEvent details:@{@"name": [NSString stringWithFormat:@"%@ %@", direction, name],
                                                                      @"gar_tag": self.garsString}];
    
    self.lastGerofence = name;
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
    // Enter Front Entrance Beacon
    if ( [visit.transmitter.identifier isEqualToString:@"KWAW-18BEH"] ) {
        [self localNotificationWithMessage:[[NSString alloc] initWithFormat:@"You arrived at %@. I am the Entrance Beacon. You seem bigger - I hope you can fit though the door.", currentTime()]
                                  userInfo:@{@"Event": [NSString stringWithFormat:@"Arrived to %@", visit.transmitter.name],
                                             @"Datetime": currentDate(),
                                             @"name": visit.transmitter.name.description
                                             }];
        if( [self.lastGerofence isEqualToString:@"Peets Coffee - 4th & Harrison"] ) {
            [self localNotificationWithMessage:[[NSString alloc] initWithFormat:@"You arrived at %@. I am the Entrance Beacon. You seem bigger - I hope you can fit though the door.", currentTime()]
                                      userInfo:@{@"Event": [NSString stringWithFormat:@"Arrived to %@", visit.transmitter.name],
                                                 @"Datetime": currentDate(),
                                                 @"name": visit.transmitter.name.description
                                                 }];
        }
    }
    
    // Hit strairs beacon
    if ( [visit.transmitter.identifier isEqualToString:@"RN4T-K8WWG"] && (self.lastOfficeEnterTime.length > 0 ) ) {
        [self localNotificationWithMessage:@"You just came back from Peets. That better not be a muffin in your hand"
                                  userInfo:@{@"Event": [NSString stringWithFormat:@"Arrived to %@", visit.transmitter.name],
                                             @"Datetime": currentDate(),
                                             @"name": visit.transmitter.name.description
                                             }];
    }
    
    // this will be invoked when an authorized transmitter is sighted for the first time
    NSString *message = [NSString stringWithFormat:@"Proximity Event: Arrived to %@", visit.transmitter.name];
    
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);
    
    [[DataSnapClient sharedClient] locationEvent:visit details:@{@"event_type": @"beacon_arrive",
                                                                 @"gar_tag": self.garsString}];
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    // In the kitchen for a minute
    if( (round(visit.dwellTime) == 60) && ([visit.transmitter.identifier isEqualToString:@"YUA5-7JWW9"]) ) {
        [self localNotificationWithMessage:@"You're in the kitchen. You're fat - stop eating trail mix"
                                  userInfo:@{@"Event": @"Kitchen for a minute",
                                             @"Datetime": currentDate(),
                                             @"Name": visit.transmitter.name}];
    }
    [[DataSnapClient sharedClient] locationEvent:visit details:@{@"rssi":RSSI,
                                                                 @"gar_tag": self.garsString}];
}

- (void)didDepart:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter has not been sighted for some time
    NSString *message = [NSString stringWithFormat:@"Proximity Event: Left %@\nDwell Time %f", visit.transmitter.name, visit.dwellTime];
    
    DeviceLog(@"%@\n", message);
    
    [[DataSnapClient sharedClient] locationEvent:visit details:@{@"event_type": @"beacon_depart",
                                                                 @"gar_tag": self.garsString}];
}

-(void) localNotificationWithMessage:(NSString *)message userInfo:(NSDictionary *)userInfo{
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.alertBody = message;
    localNotification.userInfo = userInfo;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void) lunchReminder {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [NSDateComponents new];
    [components setDay: 12];
    [components setMonth: 8];
    [components setYear: 2014];
    [components setHour: 12];
    [components setMinute: 0];
    [components setSecond: 0];
    [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
    NSDate *dateToFire = [calendar dateFromComponents:components];
    
    UILocalNotification *notification = [UILocalNotification new];
    notification.fireDate = dateToFire;
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.alertBody = [NSString stringWithFormat: @"I'd remind you to get lunch, but you really need to stop eating"];
    notification.userInfo= @{@"Event": @"Lunch reminder",
                             @"Datetime": currentDate()};
    notification.repeatInterval= kCFCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification] ;

}

@end


