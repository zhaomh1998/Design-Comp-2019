#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "GoogleMaps/GoogleMaps.h"

@import UIKit;
@import Firebase;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FIRApp configure];
  [GMSServices provideAPIKey:@"GOOGLE_MAP_API_KEY_HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
