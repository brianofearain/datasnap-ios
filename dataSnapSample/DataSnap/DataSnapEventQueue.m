#import "DataSnapEventQueue.h"

@interface DataSnapEventQueue ()

@property NSMutableArray *eventQueue;

@end

@implementation DataSnapEventQueue

- (id)initWithSize:(NSInteger)queueLength{
    if (self = [self init]) {
        self.queueLength = queueLength;
    }
    return self;
}

- (instancetype)init {
    if(self = [super init]) {
        self.eventQueue = [NSMutableArray new];
    }
    return self;
}

- (void)recordEvent:(NSDictionary *)details{
    
    // TODO hanldle generic request data (like orgID) here
    [self.eventQueue addObject:details];
    
    return;
}

- (NSArray *)getEvents {
    return self.eventQueue;
}

- (void)flushQueue {
    [self.eventQueue removeAllObjects];
}

-(NSInteger)numberOfQueuedEvents {
    return self.eventQueue.count;
}

@end
