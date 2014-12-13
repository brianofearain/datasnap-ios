#import "DataSnapGimbleIntegration.h"
#import "DataSnapClient.h"
#import "GlobalUtilities.h"
#import "DataSnapLocation.h"
#import <FYX/FYXTransmitter.h>
#import <ContextLocation/QLPlaceEvent.h>
#import <ContextLocation/QLPlace.h>
#import <ContextLocation/QLGeoFence.h>
#import <ContextLocation/QLGeoFenceCircle.h>
#import <ContextLocation/QLGeoFencePolygon.h>
#import <ContextLocation/QLLocation.h>

@implementation DataSnapGimbleIntegration

+ (void)load {
    [DataSnapClient registerIntegration:[self new] withIdentifier:@"Gimbal"];
}

- (id)init {
    if (self = [super init]) {
        self.name = @"Gimble";
    }
    
    return self;
}

+ (NSDictionary *)interactionEvent:(NSObject *)obj details:(NSDictionary *)details org:(NSString *)orgID proj: (NSString *)projID {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[self getUserAndDataSnapDictionaryWithOrgAndProj:orgID projId:projID]];
    [eventData addEntriesFromDictionary:@{@"event_type": @"interaction_event",
            @"communication_id": details[@"commidString"],
    }];

    return eventData;

}


+ (NSDictionary *)interactionEvent:(NSDictionary *)details org:(NSString *)orgID proj: (NSString *)projID {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[self getUserAndDataSnapDictionaryWithOrgAndProj:orgID projId:projID]];
    [eventData addEntriesFromDictionary:@{@"event_type": @"interaction_event",
            @"communication_id": details[@"CommunicationId"],
    }];

    return eventData;

}


+ (NSDictionary *)interactionEvent:(NSDictionary *)details tap:(NSString *)tap org:(NSString *)orgID proj: (NSString *)projID {
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[self getUserAndDataSnapDictionaryWithOrgAndProj:orgID projId:projID]];
    [eventData addEntriesFromDictionary:@{@"event_type": tap, @"communication_id": details[@"CommunicationId"],
    }];

    return eventData;

}

+ (NSDictionary *)locationEvent:(NSObject *)obj details:(NSDictionary *)details org:(NSString *)orgID proj: (NSString *)projID{
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] initWithDictionary:[self getUserAndDataSnapDictionaryWithOrgAndProj:orgID projId:projID]];
    // Beacon Event
    if([obj isKindOfClass:[FYXVisit class]]) {
        
        // Cast object to visit
        FYXVisit *visit = (FYXVisit *)obj;
        
        // Create dictionary from visit properties
        NSMutableDictionary *beacon= [[NSMutableDictionary alloc] initWithDictionary:[self dictionaryRepresentation:visit]];
        [beacon addEntriesFromDictionary:[self dictionaryRepresentation:visit.transmitter]];
        [beacon removeObjectForKey:@"transmitter"];
        beacon[@"hardware"] = @"Gimble";
        
        if ([details objectForKey:@"rssi"]) beacon[@"rssi"] = details[@"rssi"];
        
        
        
        beacon = [self map:beacon withMap:@{@"identifier": @"identifier",
                                   @"battery": @"battery_level",
                                   @"dwellTime": @"dwell_time",
                                   @"lastUpdateTime": @"last_update_time",
                                   @"startTime": @"start_time"}];
        
        // handle NSDates
        [GlobalUtilities nsdateToNSString:beacon];
        
        NSString *event_type;
        if ([details objectForKey:@"event_type"]) {
            event_type = details[@"event_type"];
        }
        else {
            event_type = @"beacon_sighting";
        }
        
        //deal with global_distinct_id
        if([details objectForKey:@"global_distinct_id"]){
            eventData[@"user"][@"id"][@"global_distinct_id"] = details[@"global_distinct_id"];
        }else{
            eventData[@"user"][@"id"][@"global_distinct_id"] = [GlobalUtilities getUUID];
        }
        
        [eventData addEntriesFromDictionary:@{@"event_type": event_type,
                                              @"beacon": beacon}];
    }
    
    // Geofence Event
    else if ([obj isKindOfClass:[QLPlaceEvent class]]) {
        
        // Cast object to QLPlaceEvent
        QLPlaceEvent *placeEvent = (QLPlaceEvent *)obj;
        NSDictionary *geoFence;
        
        // Arrive or depart
        NSString *event_type;
        if (placeEvent.eventType == QLPlaceEventTypeAt) {
            event_type = @"geofence_arrive";
        }
        else if (placeEvent.eventType == QLPlaceEventTypeLeft) {
            event_type = @"geofence_depart";
        }
        else {
            event_type = @"geofence_event";
        }
            
        
        // Circle geofence
        if ([[[placeEvent place] geoFence] isKindOfClass:[QLGeoFenceCircle class]]) {
            
            QLGeoFenceCircle *fence = (QLGeoFenceCircle *)[[placeEvent place] geoFence];
            double latitude = [fence latitude];
            double longitude = [fence longitude];
            NSArray *coords = [[DataSnapLocation sharedInstance] getLocationCoordinatesFromDouble:latitude longitude:longitude];
            geoFence = @{@"time": [[placeEvent time] description],
                         @"identifier": [NSNumber numberWithLongLong:[[placeEvent place] id]],
                         @"name": [[placeEvent place] name],
                         @"geofence_circle": @{@"radius": [NSNumber numberWithDouble:[fence radius]],
                                               @"location": @{@"coordinates": coords}}};
        }
        // Polygon geofence
        else if ([[[placeEvent place] geoFence] isKindOfClass:[QLGeofencePolygon class]]) {
            
            QLGeofencePolygon *fence = (QLGeofencePolygon *)[[placeEvent place] geoFence];

            NSMutableArray *locations = [NSMutableArray new];
            for(QLLocation *loc in [fence locations]) {
                NSNumber *latitude = [loc latitude];
                NSNumber *longitude = [loc longitude];
                NSArray *coords = [[DataSnapLocation sharedInstance] getLocationCoordinates:latitude longitude:longitude];
                [locations addObject:@{@"coordinates": coords}];
            }
            
            geoFence = @{@"time": [[placeEvent time] description],
                         @"identifier": [NSNumber numberWithLongLong:[[placeEvent place] id]],
                         @"name": [[placeEvent place] name],
                         @"geofence_polygon": @{@"locations": locations}};
        }
        
        [eventData addEntriesFromDictionary:@{@"event_type": event_type,
                                              @"name": details[@"name"],
                                              @"geofence": geoFence}];
    }
    
    return eventData;
}

@end
