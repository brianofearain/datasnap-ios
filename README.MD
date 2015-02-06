DataSnapClient
=================

An iOS SDK for [DataSnap.io](http://datasnap.io)

## Documentation

### Quickstart

1. Link DataSnapClient.framework to your project.
2. `#import "DataSnapClient/Client.h"` in your source
3. `[DataSnapClient setupWithOrganizationID:@"" APIKey:@"" APISecret:@""]`

### Example Events

```objective-c
[[DataSnapClient sharedClient] genericEvent:@{@"key": @"value"}]

[[DataSnapClient sharedClient] locationEvent:(FYXVisit *)visit details:@{@"event_type": @"beacon_arrive"}]

[[DataSnapClient sharedClient] locationEvent:(QLPlaceEvent *)placeEvent details:@{@"name": @"Geofence Event"}]
```
