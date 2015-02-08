#import <Foundation/Foundation.h>

@interface DSIORequest : NSObject

- (id)initWithURL:(NSString *)url authString:(NSString *)authString;
- (void)sendEvents:(NSObject *)events;

@end
