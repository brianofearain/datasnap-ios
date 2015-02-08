//
//  Copyright (c) 2014 Datasnap.io. All rights reserved.
//  Datasnap Generic Sample


#import "ViewController.h"
#import "DSIOClient.h"
#import "DSIOPropertiesSampleData.h"
#import "DSIOProperties.h"


// Get current datetime
NSString *currentDate() {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *date = [NSDate new];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
}

@interface ViewController ()

@end

@implementation ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [self buildBeaconSightingEvent];

   // commenting out for now - just getting layout right for beacon events first then will reuse the format on all the other events
  //  [self buildGenericEvent];
  //  [self buildGeofenceDepartEvent];
  //  [self buildCommunicationEvent];

    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self
                                   selector:@selector(callEvents:) userInfo:nil repeats:YES];
}


// mimic events - for sample scenario without an event listener configured
- (void)callEvents:(NSTimer *)t {
    [self buildBeaconSightingEvent];
   // [self buildGenericEvent];
   // [self buildGeofenceDepartEvent];
   // [self buildCommunicationEvent];
}

- (void)logToDeviceAndConsole:(NSString *)eventName{
    NSString *eventAndTime = [NSString stringWithFormat:eventName, currentDate()];
    NSString *message = [NSString stringWithFormat:@"%@\n", eventAndTime];
    NSLog(message);
    DeviceLog(message);
}

- (void)buildBeaconSightingEvent{
    NSMutableDictionary *eventData = [self getSampleBeaconSightingEvent];
    [[DSIOClient sharedClient] beaconSightingEvent:eventData];
    [self logToDeviceAndConsole:@"Datasnap Beacon Sighting Event %@"];
}

- (NSMutableDictionary *) getSampleBeaconSightingEvent{
    NSArray *beaconSightingSampleValues =  [DSIOPropertiesSampleData getBeaconSightingEventSampleValues] ;
    NSArray *beaconSightingEventKeys =  [DSIOProperties getBeaconSightingEventKeys] ;
    NSMutableDictionary *beaconSighting = [NSMutableDictionary dictionaryWithObjects:beaconSightingSampleValues forKeys:beaconSightingEventKeys];
    return beaconSighting;
}


- (NSMutableDictionary *)buildGeofenceDepartEvent {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];

    NSMutableDictionary *geoFence = [[NSMutableDictionary alloc] init];
    geoFence = @{@"time" : currentDate(),
            @"identifier" : @"12qAS5",
            @"name" : @"geofence123",
            @"geofence_circle" : @{@"radius" : @"34",
                    @"location" : @{@"coordinates" : @"123, 456"}}};

    NSMutableDictionary *place = [self buildPlace];
    NSMutableDictionary *user = [self buildUser];

    [eventData addEntriesFromDictionary:@{@"event_type" : @"geofence_depart", @"geofence" : geoFence, @"organization_ids" : @"3HRhnUtmtXnT1UHQHClAcP"
    , @"project_ids" : @"3HRhnUtmtXnT1UHQHClAcP", @"place" : place, @"user" : user}];
    [[DSIOClient sharedClient] geofenceArriveEvent:eventData];
    [self logToDeviceAndConsole:@"Datasnap Geofence Depart Event %@"];
    return eventData;
}

- (NSMutableDictionary *)buildCommunicationEvent {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    [content addEntriesFromDictionary:@{@"text" : @"Get 50% off your meal"}];
    NSMutableDictionary *communication = [[NSMutableDictionary alloc] init];
    [communication addEntriesFromDictionary:@{@"communication_id" : @"uniquecommunication12", @"content" : content}];
    [eventData addEntriesFromDictionary:@{@"event_type" : @"ds_communication_sent", @"communication" : communication}];
    [self logToDeviceAndConsole:@"Datasnap Communication Event %@"];
    return eventData;

}

- (NSMutableDictionary *)buildUser {
    NSMutableDictionary *user =  [[DSIOClient sharedClient] getUserInfo];
    return user;
}

- (NSMutableDictionary *)buildPlace {
    NSMutableDictionary *place = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *placeDictionnary = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *beaconDictionnary = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
        placeDictionnary =  @{@"id" : @"placeid",
            @"name" : @"Mission District"};

    beaconDictionnary =  @{@"beaconid" : @"ASD-3e4",
            @"beaconid" : @"HYF-3e4"};

    addressDictionary =  @{@"address1": @"103 west street",
                       @"address2": @"",
                       @"city": @"San Francisco",
                       @"region": @"CA",
                       @"zip": @"94107",
                       @"zip4": @"3422"};

    return addressDictionary;

}

- (NSMutableDictionary *)buildGenericEvent {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *genericProperties = [[NSMutableDictionary alloc] init];
    genericProperties[@"dwell_time"] = @"12";
    genericProperties[@"custom property"] = @"my custom property";
    [eventData addEntriesFromDictionary:@{@"event_type" : @"generic_event", @"generic" : genericProperties}];
    [[DSIOClient sharedClient] genericEvent:eventData];
    [self logToDeviceAndConsole:@"Datasnap Generic Event %@"];
    return eventData;
}


@end


