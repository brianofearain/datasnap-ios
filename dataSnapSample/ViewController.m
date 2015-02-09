//
//  Copyright (c) 2014 Datasnap.io. All rights reserved.
//  Datasnap Generic Sample


#import "ViewController.h"
#import "DSIOClient.h"
#import "DSIOSampleData.h"
#import "DSIOProperties.h"
#import "DSIOEvents.h"


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
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self
                                   selector:@selector(callEvents:) userInfo:nil repeats:YES];
}


// mimic events - for sample scenario without an event listener configured
- (void)callEvents:(NSTimer *)t {
    [self buildBeaconSightingEvent];
}

- (void)logToDeviceAndConsole:(NSString *)eventName{
    NSString *eventAndTime = [NSString stringWithFormat:eventName, currentDate()];
    NSString *message = [NSString stringWithFormat:@"%@\n", eventAndTime];
    NSLog(message);
    DeviceLog(message);
}

- (void)buildBeaconSightingEvent{
    NSArray *beaconSampleValues =  [DSIOSampleData getBeaconEventSampleValues] ;
    NSArray *beaconEventKeys = [DSIOEvents getBeaconEventKeys] ;
    NSMutableDictionary *beaconSighting = [NSMutableDictionary dictionaryWithObjects:beaconSampleValues forKeys:beaconEventKeys];
    [[DSIOClient sharedClient] beaconEvent:beaconSighting];
    [self logToDeviceAndConsole:@"Datasnap Beacon Sighting Event %@"];
}




@end


