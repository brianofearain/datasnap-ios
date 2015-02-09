//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import "DSIOEvents.h"


@implementation DSIOEvents


// need to add in place
 + (NSArray *)getBeaconEventKeys {
        return @[@"event_type",
                @"organization_ids",
                @"project_ids",
                @"beacon"];
    }

+ (NSArray *)getInteractionEventKeys {
    return @[@"event_type",
            @"organization_ids",
            @"project_ids",
            @"place",
            @"communication",
            @"user",
            @"campaign",
            @"datasnap"];
}


+ (NSArray *)getGeofenceEventKeys {
    return @[@"event_type",
            @"organization_ids",
            @"project_ids",
            @"place",
            @"geofence",
            @"user"];
}

+ (NSArray *)getCommunicationEventKeys {
    return @[@"event_type",
            @"organization_ids",
            @"project_ids",
            @"user",
            @"communication",
            @"campaign"];

}

+ (NSArray *)getGlobalPositionEventKeys {
    return @[@"event_type",
            @"organization_ids",
            @"project_ids",
            @"user",
            @"global_position",
            @"datasnap"];

}

+ (NSArray *)getPlaceEventKeys {
    return @[@"event_type",
            @"organization_ids",
            @"project_ids",
            @"user",
            @"global_position",
            @"datasnap"];

}


@end