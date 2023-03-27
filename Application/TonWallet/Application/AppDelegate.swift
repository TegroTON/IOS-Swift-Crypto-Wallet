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
        
        let navVC = RootNavigationController.shared
        navVC.setViewControllers([rootVC], animated: false)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("💙 open url \(url)")
        
        return true
    }

}

