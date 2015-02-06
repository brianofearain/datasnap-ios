#import <Foundation/Foundation.h>

@interface DataSnapRequest : NSObject

-(id)initWithURL:(NSString *)url authString:(NSString *)authString;

-(void)sendEvents:(NSObject *)events;

@end
