//
//  geofence.h
//  gimbalDemo
//
//  Created by Mark Watson on 8/7/14.
//  Copyright (c) 2014 Datasnap.io. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ContextLocation/QLContextPlaceConnector.h>

@interface Geofence : NSObject <QLContextPlaceConnectorDelegate>

@property (nonatomic) QLContextPlaceConnector *placeConnector;

@end
