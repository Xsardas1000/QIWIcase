@import UIKit;
@import SinchVerification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [SINVerification setLogCallback:^(SINVLogSeverity severity, NSString *area, NSString *message, NSDate *timestamp) {
    NSLog(@"%@ | %@", timestamp, message);
  }];
  return YES;
}

@end

int main(int argc, char *argv[]) {
  @autoreleasepool {
    return UIApplicationMain(argc, argv, nil, @"AppDelegate");
  }
}
