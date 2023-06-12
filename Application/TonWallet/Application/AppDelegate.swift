import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootVC: UIViewController
         
        if WalletManager.shared.wallets.isEmpty {
            rootVC = CreateViewController()
        } else {
            var passwordVC: PasswordViewController
            let password = KeychainManager().getPassword()
            
            if password == nil || password?.isEmpty == true {
                passwordVC = PasswordViewController(type: .create)
            } else {
                passwordVC = PasswordViewController(type: .login)
            }
            
            passwordVC.successHandler = { _ in
                RootNavigationController.shared.setViewControllers([TabBarViewController()], animated: true)
            }
            
            rootVC = passwordVC
        }
        
//        UserSettings.shared.connections = []
//        UserSettings.shared.lastEventId = nil
        SSEClient.shared.connectToSSE()
        WalletManager.shared.loadAccounts()
        
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

