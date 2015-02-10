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
  // [self buildGeofenceEvent];
  // [self buildPlaceEvent];
  // [self buildGlobalPositionEvent];
  // [self buildCommunicationEvent];
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self
                                   selector:@selector(callEvents:) userInfo:nil repeats:YES];
}


// mimic events - for sample scenario without an event listener configured
- (void)callEvents:(NSTimer *)t {
    [self buildBeaconEvent];
  //  [self buildGeofenceEvent];
  //  [self buildPlaceEvent];
  //  [self buildGlobalPositionEvent];
  //  [self buildCommunicationEvent];
}

- (void)logToDeviceAndConsole:(NSString *)eventName{
    NSString *eventAndTime = [NSString stringWithFormat:eventName, currentDate()];
    NSString *message = [NSString stringWithFormat:@"%@\n", eventAndTime];
    NSLog(message);
    DeviceLog(message);
}

- (void)buildBeaconEvent{
    NSArray *beaconEventSampleValues =  [DSIOSampleData getBeaconEventSampleValues] ;
    NSArray *beaconEventKeys = [DSIOEvents getBeaconEventKeys] ;
    NSMutableDictionary *beaconSighting = [NSMutableDictionary dictionaryWithObjects:beaconEventSampleValues forKeys:beaconEventKeys];
    [[DSIOClient sharedClient] beaconEvent:beaconSighting];
    [self logToDeviceAndConsole:@"Datasnap Beacon Sighting Event %@"];
}

- (void)buildGeofenceEvent{
    NSArray *geofenceEventSampleValues =  [DSIOSampleData getGeofenceEventSampleValues] ;
    NSArray *geofenceEventKeys = [DSIOEvents getGeofenceEventKeys] ;
    NSMutableDictionary *geoEvent = [NSMutableDictionary dictionaryWithObjects:geofenceEventSampleValues forKeys:geofenceEventKeys];
    [[DSIOClient sharedClient] beaconEvent:geoEvent];
    [self logToDeviceAndConsole:@"Datasnap Geofence Sighting Event %@"];
}

- (void)buildPlaceEvent{
    NSArray *placeEventSampleValues =  [DSIOSampleData getPlaceEventSampleValues] ;
    NSArray *placeEventKeys = [DSIOEvents getPlaceEventKeys] ;
    NSMutableDictionary *place = [NSMutableDictionary dictionaryWithObjects:placeEventSampleValues forKeys:placeEventKeys];
    [[DSIOClient sharedClient] placeEvent:place];
    [self logToDeviceAndConsole:@"Datasnap Place Event %@"];
}

- (void)buildGlobalPositionEvent{
    NSArray *globalPositionEventSampleValues =  [DSIOSampleData getGlobalPositionEventSampleValues] ;
    NSArray *globalPositionEventKeys = [DSIOEvents getGlobalPositionEventKeys] ;
    NSMutableDictionary *globalPosition = [NSMutableDictionary dictionaryWithObjects:globalPositionEventSampleValues forKeys:globalPositionEventKeys];
    [[DSIOClient sharedClient] globalPositionEvent:globalPosition];
    [self logToDeviceAndConsole:@"Datasnap Global Position Sighting Event %@"];
}

- (void)buildCommunicationEvent{
    NSArray *communicationEventSampleValues =  [DSIOSampleData getCommunicationEventSampleValues] ;
    NSArray *communicationEventKeys = [DSIOEvents getCommunicationEventKeys] ;
    NSMutableDictionary *communication = [NSMutableDictionary dictionaryWithObjects:communicationEventSampleValues forKeys:communicationEventKeys];
    [[DSIOClient sharedClient] communicationEvent:communication];
    [self logToDeviceAndConsole:@"Datasnap Communication Event %@"];
}

//- (void)buildCampaignEvent{
//    NSArray *campaignEventSampleValues =  [DSIOSampleData getCampaignEventSampleValues] ;
//    NSArray *campaignEventKeys = [DSIOEvents getCampaignEventKeys] ;
//    NSMutableDictionary *campaign = [NSMutableDictionary dictionaryWithObjects:campaignEventSampleValues forKeys:campaignEventKeys];
//    [[DSIOClient sharedClient] campaignEvent:campaign];
//    [self logToDeviceAndConsole:@"Datasnap Global Position Sighting Event %@"];
//}





@end


