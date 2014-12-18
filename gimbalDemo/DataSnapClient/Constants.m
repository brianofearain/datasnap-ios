#import "Constants.h"

//  API constants
NSString * const NameParam = @"name";
NSString * const DescriptionParam = @"description";
NSString * const SuccessParam = @"success";
NSString * const ErrorParam = @"error";
NSString * const InvalidCollectionNameError = @"InvalidCollectionNameError";
NSString * const InvalidPropertyNameError = @"InvalidPropertyNameError";
NSString * const InvalidPropertyValueError = @"InvalidPropertyValueError";

// Keen constants related to how much data we'll cache on the device before aging it out

// how many events can be stored for a single collection before aging them out
NSUInteger const MaxEventsPerCollection = 10000;
// how many events to drop when aging out
NSUInteger const NumberEventsToForget = 100;

// custom domain for NSErrors
NSString * const ErrorDomain = @"io.keen";