//
//  geofence.m
//  gimbalDemo
//
//  Created by Mark Watson on 8/7/14.
//  Copyright (c) 2014 Datasnap.io. All rights reserved.
//

#import "Geofence.h"

#import <ContextLocation/QLPlaceEvent.h>
#import <ContextLocation/QLPlace.h>
#import <ContextCore/QLContentConnector.h>

@implementation Geofence

- (id) init {
    if( self = [super init]) {
        
        self. = [[QLContextCoreConnector alloc] init];
        self.permissionsDelegate = self;
        
        self.contextPlaceConnector = [[QLContextPlaceConnector alloc] init];
        self.contextPlaceConnector.delegate = self;
        
        self.contextInterestsConnector = [[PRContextInterestsConnector alloc] init];
        self.contextInterestsConnector.delegate = self;
        
        self.contentConnector = [[QLContentConnector alloc] init];
        self.contentConnector.delegate = self;
        
    }
    return self;
}

- (void)didGetPlaceEvent:(QLPlaceEvent *)placeEvent
{
    QLPlaceEventType placeType = [placeEvent eventType];
    
    if (placeType == QLPlaceEventTypeAt) {
        NSLog(@"Arrived at %@", [placeEvent place].name);
    }
    else if (placeType == QLPlaceEventTypeLeft) {
        NSLog(@"Left %@", [placeEvent place].name);
    }
}

@end
