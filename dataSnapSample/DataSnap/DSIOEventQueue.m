//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import "DSIOEventQueue.h"

@interface DSIOEventQueue ()

@property NSMutableArray *eventQueue;

@end

@implementation DSIOEventQueue

- (id)initWithSize:(NSInteger)queueLength {
    if (self = [self init]) {
        self.queueLength = queueLength;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.eventQueue = [NSMutableArray new];
    }
    return self;
}

- (void)recordEvent:(NSDictionary *)details {
    [self.eventQueue addObject:details];
    return;
}

- (NSArray *)getEvents {
    return self.eventQueue;
}

- (void)flushQueue {
    [self.eventQueue removeAllObjects];
}

- (NSInteger)numberOfQueuedEvents {
    return self.eventQueue.count;
}

@end
