#import <Foundation/Foundation.h>

@interface DataSnapEventQueue : NSObject

/**
 Number of events to batch
 */
@property NSInteger queueLength;

/**
 Create event queue
 */
- (id)initWithSize:(NSInteger)queueLength;

/**
 Record an event
 */
- (void)recordEvent:(NSDictionary *)details;

/**
 Flush all events
 */
- (void)flushQueue;

/**
 Return events in queue (have not been sent)
 */
- (NSArray *)getEvents;

/**
 Return number of events in queue
 */
- (NSInteger)numberOfQueuedEvents;

@end
