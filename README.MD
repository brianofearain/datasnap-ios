DataSnapClient
=================

An Vendor neutral iOS Sample app and SDK for [DataSnap.io](http://datasnap.io)

## Documentation:

See http://datasnap-io.github.io/sendingdata/ for more information on event types.

### Quickstart

1. `#import "DataSnapClient/DSIOClient.h"` in your source
2. `[DSIOClient setupWithOrgAndProjIDs:@"" projectId:@"" APIKey:@"" APISecret:@""]`

### How to send events

DSIOEvents contains arrays with keys, representing the properties required for each event type.
DSIOProperties contains dictionaries for showing how to build each of the these properties.
The ViewController in the sample, contains a fully worked out Beacon Sighting Event using sample data.


### Example Event:

```objective-c
    NSMutableDictionary *beaconSighting = [NSMutableDictionary dictionaryWithObjects:beaconSampleValues forKeys:beaconEventKeys];
    [[DSIOClient sharedClient] beaconEvent:beaconSighting];
```
