import UIKit
import shared

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let ton = Ton()
        let liteClient = ton.doInitLiteClient()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootNavigationController(rootViewController: MainViewController())
        window?.makeKeyAndVisible()
        
        return true
    }


}

