(IN TESTING ) DataSnapClient
=================

An Vendor neutral iOS Sample app and SDK for [DataSnap.io](http://datasnap.io)

## Documentation

### Quickstart

1. `#import "DataSnapClient/Client.h"` in your source
2. `[DataSnapClient setupWithOrgAndProjIDs:@"" projectId:@"" APIKey:@"" APISecret:@""]`

### Example Events

```objective-c
[[DataSnapClient sharedClient] genericEvent:@{@"key": @"value"}]

[[DataSnapClient sharedClient] beaconSightingEvent:(NSMutableDictionary *)eventDetails]

[[DataSnapClient sharedClient] geofenceArriveEvent:(NSMutableDictionary *)eventDetails]
```
