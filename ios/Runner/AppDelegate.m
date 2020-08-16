#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "PlatformTextViewFactory.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* channel = [FlutterMethodChannel
                                          methodChannelWithName:@"com.funny_flutter.todo_list.channel"
                                          binaryMessenger:controller.binaryMessenger];

  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      if ([call.method isEqualToString:@"getCurrentLocation"]) {
          result(@{
              @"latitude": @"39.92",
              @"longitude": @"116.46",
              @"description": @"北京",
          });
      } else {
          result(FlutterMethodNotImplemented);
      }
  }];
  PlatformTextViewFactory *factory = [[PlatformTextViewFactory alloc] init];
  [[self registrarForPlugin:@"com.funny_flutter.todo_list.view"] registerViewFactory:factory withId:@"platform_text_view"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
