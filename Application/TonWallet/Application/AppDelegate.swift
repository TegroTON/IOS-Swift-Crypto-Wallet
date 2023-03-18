import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootVC: UIViewController
         
        if WalletManager.shared.wallets.isEmpty {
            rootVC = CreateViewController()
        } else {
            rootVC = TabBarViewController()
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootNavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
        
        return true
    }


}

