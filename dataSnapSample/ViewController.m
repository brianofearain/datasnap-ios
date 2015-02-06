//
//  Copyright (c) 2014 Datasnap.io. All rights reserved.
//  Datasnap Generic Sample


#import "ViewController.h"
#import "DataSnapClient.h"


// Get current datetime
NSString* currentDate() {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
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
    [self buildBeaconSightingEvent] ;
    [self buildGenericEvent] ;
    [self buildGeofenceDepartEvent] ;
    [self buildCommunicationEvent] ;
     NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self
                                                      selector: @selector(callEvents:) userInfo: nil repeats: YES];
}

-(void) callEvents :(NSTimer*) t{
[self buildBeaconSightingEvent] ;
    [self buildGenericEvent] ;
    [self buildGeofenceDepartEvent] ;
    [self buildCommunicationEvent] ;

}


- (NSMutableDictionary *)buildBeaconSightingEvent{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];

    // Create dictionary from a beacons properties
    NSMutableDictionary *beacon= [[NSMutableDictionary alloc] init];

    // here are some sample properties..
    beacon[@"hardware"] = @"Hardwarevendor1";
    beacon[@"last_update_time"] = @"xxa-12312-1231-asads";
    beacon[@"start_time"] = @"2014-02-05 23:51:58 +0000";
    beacon[@"identifier"] = @"POLUBPQ-Z42X2";
    beacon[@"rssi"] = @"-95";
    beacon[@"temperature"] = @"63";


    NSString *name = @"";
    NSString *message = [NSString new];
    message = [NSString stringWithFormat:@"Datasnap Beacon Sighting Event %@", currentDate()];

    [eventData addEntriesFromDictionary:@{@"event_type" : @"beacon_sighting", @"beacon" : beacon}];

    [[DataSnapClient sharedClient] beaconSightingEvent:eventData];
    return eventData;
}

- (NSMutableDictionary *)buildGeofenceDepartEvent{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];

    // this is a geofence circle- see sending data for more examples...

    // Create dictionary from a beacons properties
    NSMutableDictionary *geoFence= [[NSMutableDictionary alloc] init];


    geoFence = @{@"time": currentDate(),
            @"identifier": @"12qAS5",
            @"name": @"geofence123",
            @"geofence_circle": @{@"radius": @"34",
                    @"location": @{@"coordinates": @"123, 456"}}};


    NSString *name = @"";
    NSString *message = [NSString new];
    message = [NSString stringWithFormat:@"Datasnap Geofence Depart Event %@", currentDate()];
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);


    [eventData addEntriesFromDictionary:@{@"event_type" : @"geofence_depart", @"geofence" : geoFence}];

    [[DataSnapClient sharedClient] geofenceArriveEvent:eventData];

    return eventData;
}

- (NSMutableDictionary *)buildCommunicationEvent{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
   // communication event
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    [content addEntriesFromDictionary:@{@"text" : @"Get 50% off your meal"}];
    NSMutableDictionary *communication = [[NSMutableDictionary alloc] init];
    [communication addEntriesFromDictionary:@{@"communication_id" : @"uniquecommunication12", @"content" : content}];
    [eventData addEntriesFromDictionary:@{@"event_type" : @"ds_communication_sent", @"communication" : communication}];

    NSString *name = @"";
    NSString *message = [NSString new];
    message = [NSString stringWithFormat:@"Datasnap Communication Event %@", currentDate()];
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);
    return eventData;

}


- (NSMutableDictionary *)buildGenericEvent{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    NSString *name = @"";
    NSString *message = [NSString new];
    // Create dictionary of generic
    NSMutableDictionary *genericProperties= [[NSMutableDictionary alloc] init];

    // here are some sample properties..
    genericProperties[@"dwell_time"] = @"12";
    genericProperties[@"custom property"] = @"my custom property";


    message = [NSString stringWithFormat:@"Datasnap Generic Event %@", currentDate()];
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);
    [eventData addEntriesFromDictionary:@{@"event_type" : @"generic_event", @"generic" : genericProperties}];

    [[DataSnapClient sharedClient] genericEvent:eventData];


    return eventData;
}


@end


