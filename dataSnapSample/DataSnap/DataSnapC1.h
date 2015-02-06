#import <Foundation/Foundation.h>

@protocol DataSnapC1 <NSObject>

+ (NSDictionary *)locationEvent:(NSObject *)obj details:(NSDictionary *)details org:(NSString *)orgID;


@end

@interface DataSnapC1 : NSObject

+ (NSMutableDictionary *)map:(NSDictionary *)dictionary withMap:(NSDictionary *)map;

+ (NSDictionary *)dictionaryRepresentation:(NSObject *)obj;

+ (NSDictionary *)getUserAndDataSnapDictionaryWithOrgAndProj:(NSString *)orgID projId: (NSString *)projID;
@end

