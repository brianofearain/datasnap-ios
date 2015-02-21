//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import "ViewController.h"
#import "DSIOClient.h"
#import "DSIOSampleData.h"
#import "DSIOProperties.h"
#import "DSIOEvents.h"

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
    [self buildBeaconEvent];
    [self buildGenericEvent];


    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self
                                   selector:@selector(callEvents:) userInfo:nil repeats:YES];
}


// mimic events - for sample scenario without an event listener configured
- (void)callEvents:(NSTimer *)t {
    [self buildBeaconEvent];
    [self buildGenericEvent];

}

- (void)logToDeviceAndConsole:(NSString *)eventName{
    NSString *eventAndTime = [NSString stringWithFormat:eventName, currentDate()];
    NSString *message = [NSString stringWithFormat:@"%@\n", eventAndTime];
    NSLog(message);
    DeviceLog(message);
}

/*
*  This sample function shows how to build a beacon sighting event.
*  The beacon data is sample data- but the other properties (user and datasnap) are obtained using real data
*  and can be reused as is in your application. The "user" property is important because the value "datasnap_app_user_id" is required
*  by the SDK.
* */

- (void)buildBeaconEvent {
    // Create a top level dictionary and pass values to it
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *beaconDictionary = [[NSMutableDictionary alloc] init];

    [beaconDictionary addEntriesFromDictionary:@{ @"identifier" : [NSString stringWithFormat:@"%@/%@/%@", @"SampleBeacon", @"123",@"23"],
            @"distance" : @"45", @"major" : @"23",
            @"minor" : @"123", @"rssi" : [NSString stringWithFormat:@"%d", 34]}];

    [eventData addEntriesFromDictionary:@{@"beacon" : beaconDictionary, @"event_type" : @"beacon_sighting",
            @"datasnap" : [DSIOProperties  getDataSnap], @"user" : [DSIOProperties getUserInfo] }];
    [[DSIOClient sharedClient] genericEvent:eventData];
    [self logToDeviceAndConsole:@"Datasnap Estimote Beacon Sighting Event %@"];
    NSLog(@"Dictionary: %@", [eventData description]);

}

/*
*  This sample function illustrates how to send events to the Datasnap API using a generic function.
*
* */

- (void)buildGenericEvent{
    // Create a top level dictionary and pass values to it
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *communication = [[NSMutableDictionary alloc] init];
    [communication addEntriesFromDictionary:@{@"identifier" : @"in_kitchen_for_a_minute", @"status":  @"background"}];
    NSMutableDictionary *dataSnapSampleValues =  [DSIOSampleData getDataSnapSampleValues] ;
    [eventData addEntriesFromDictionary:@{@"communication" : communication, @"datasnap":  dataSnapSampleValues
            ,@"event_type" : @"generic_communication_example" }];
    [[DSIOClient sharedClient] genericEvent:eventData];
    [self logToDeviceAndConsole:@"Datasnap Generic Communication Event %@"];
}


@end


