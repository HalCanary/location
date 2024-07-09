// Link with:
//   -framework AppKit
//   -framework CoreLocation 
#include <stdio.h>
#include <stdlib.h>
#include <AppKit/AppKit.h>
#include <CoreLocation/CoreLocation.h>
@interface Delegate : NSObject <CLLocationManagerDelegate, NSApplicationDelegate>
    @property (strong) CLLocationManager* mgr;
@end
@implementation Delegate
    - (void)locationManager:(CLLocationManager*)m didFailWithError:(NSError*)e {
        fprintf(stderr, "CLLocationManager error: %s\n",
            [[e localizedDescription] UTF8String]);
    }
    - (void) locationManager:(CLLocationManager*)m didUpdateLocations:(NSArray<CLLocation*>*)ls {
        for (CLLocation* l in ls) {
            printf("%f, %f", l.coordinate.latitude, l.coordinate.longitude);
        }
        [NSApp terminate:self];
    }
    - (void)applicationDidFinishLaunching:(NSNotification*)n {
        [self setMgr:[[CLLocationManager alloc] init]];
        [self.mgr setDelegate:self];
        [self.mgr setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.mgr setDistanceFilter:2.0];
        [self.mgr requestAlwaysAuthorization];
        [self.mgr startUpdatingLocation];
    }
    - (void)locationManager:(CLLocationManager*)m
            didUpdateToLocation:(CLLocation*)l
            fromLocation:(CLLocation*)ol {
        printf("%f, %f", l.coordinate.latitude, l.coordinate.longitude);
        [NSApp terminate:self];
    }
@end
int main(int argc, const char* argv[]) {
    Delegate* d = [[Delegate alloc] init];
    [[NSApplication sharedApplication] setDelegate:d];
    [[NSApplication sharedApplication] setActivationPolicy:NSApplicationActivationPolicyProhibited];
    NSApplicationMain(argc, argv);
    [d release];
    return 0;
}
