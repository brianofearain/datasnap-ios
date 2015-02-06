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
@property NSString *lastOfficeEnterTime;
@property NSString *lastGerofence;
@property NSMutableDictionary * communicationEvent;


@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{    [self buildBeaconSightingEvent] ;
    [self buildGenericEvent] ;
    [self buildGeofenceArriveEvent] ;
    [self buildGeofenceDepartEvent] ;
    [self buildCommunicationEvent] ;
     NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 15.0 target: self
                                                      selector: @selector(callEvents:) userInfo: nil repeats: YES];
}

-(void) callEvents :(NSTimer*) t{
[self buildBeaconSightingEvent] ;
    [self buildGenericEvent] ;
    [self buildGeofenceArriveEvent] ;
    [self buildGeofenceDepartEvent] ;
    [self buildCommunicationEvent] ;

}

- (NSMutableDictionary *)buildGenericEvent{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    NSString *name = @"";
    NSString *message = [NSString new];
    message = [NSString stringWithFormat:@"Datasnap Generic Event %@", currentDate()];
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);
    return eventData;
}


- (NSMutableDictionary *)buildBeaconSightingEvent{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];

  //  @"event_type": @"beacon_sighting",
    NSString *name = @"";
    NSString *message = [NSString new];
    message = [NSString stringWithFormat:@"Datasnap Beacon Sighting Event %@", currentDate()];
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);
    [[DataSnapClient sharedClient] beaconSightingEvent:eventData];
    return eventData;
}


- (NSMutableDictionary *)buildBeaconDepartEvent{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];

  //  @"event_type": @"beacon_depart",


     NSString *name = @"";
    NSString *message = [NSString new];
    message = [NSString stringWithFormat:@"Datasnap Beacon Depart Event %@", currentDate()];
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);
    [[DataSnapClient sharedClient] beaconDepartEvent:eventData];
    return eventData;
}

//[[DataSnapClient sharedClient] locationEvent:visit details:@{@"event_type": @"beacon_depart",
//            @"gar_tag": self.garsString}];


- (NSMutableDictionary *)buildGeofenceArriveEvent{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    NSString *name = @"";
    NSString *message = [NSString new];
    message = [NSString stringWithFormat:@"Datasnap Geofence Arrive Event %@", currentDate()];
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);

    [[DataSnapClient sharedClient] beaconSightingEvent:eventData];

    return eventData;
}


- (NSMutableDictionary *)buildGeofenceDepartEvent{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    NSString *name = @"";
    NSString *message = [NSString new];
    message = [NSString stringWithFormat:@"Datasnap Geofence Depart Event %@", currentDate()];
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);

    [[DataSnapClient sharedClient] beaconSightingEvent:eventData];

    return eventData;
}

- (NSMutableDictionary *)buildCommunicationEvent{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];

   // communication event
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    [content addEntriesFromDictionary:@{@"text" : @"Hope you're just getting coffee. NO MUFFIN FOR YOU!"}];
    // Create dictionary from visit properties
    NSMutableDictionary *communication = [[NSMutableDictionary alloc] init];
    [communication addEntriesFromDictionary:@{@"communication_id" : @"commidString", @"content" : content}];
    [eventData addEntriesFromDictionary:@{@"event_type" : @"ds_communication_sent", @"communication" : communication}];


    NSString *name = @"";
    NSString *message = [NSString new];
    message = [NSString stringWithFormat:@"Datasnap Communication Event %@", currentDate()];
    NSLog(@"%@", message);
    DeviceLog(@"%@\n", message);
    return eventData;

    [[DataSnapClient sharedClient] beaconSightingEvent:eventData];

}


@end


