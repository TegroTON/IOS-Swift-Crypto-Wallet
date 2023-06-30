import UIKit
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootVC: UIViewController

        if !UserSettings.shared.wallets.isEmpty {
            var passwordVC: PasswordViewController = .init(type: .login)
            passwordVC.successHandler = { _ in
                RootNavigationController.shared.setViewControllers([TabBarViewController()], animated: true)
            }
            
            rootVC = passwordVC
        } else {
            rootVC = CreateViewController()
        }

        SSEClient.shared.connectToSSE()
        WalletManager.shared.initialize()
        
        let configuration: YMMYandexMetricaConfiguration = .init(apiKey: "8db5538a-7a1a-4220-aa66-54605eedc190")!
        YMMYandexMetrica.activate(with: configuration)
        
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

