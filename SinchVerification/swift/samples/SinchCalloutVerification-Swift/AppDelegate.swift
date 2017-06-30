import UIKit;
import Foundation;
import SinchVerification;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        NSLog("Sinch Verification SDK version %@", SinchVerification.version());
      
        SinchVerification.setLogCallback { (severity:LogSeverity, area:String, message:String, timestamp:Date) in
          NSLog("%d | %@ | %@", severity.rawValue, timestamp as NSDate, message);
        };
        return true;
    }
}
