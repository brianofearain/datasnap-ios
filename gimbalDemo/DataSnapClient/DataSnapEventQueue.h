#import <Foundation/Foundation.h>

@interface DataSnapEventQueue : NSObject

/**
 Number of events to batch
 */
@property NSInteger queueLength;

@property(nonatomic, strong) id anError;

/**
 Create event queue
 */
- (id)initWithSizeAndProject:(NSInteger)queueLength projectId:(NSString *)__projectID;

- (id) getEventStore ;

- (void)checkQueue;

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
