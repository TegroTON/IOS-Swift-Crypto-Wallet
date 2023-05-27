import UIKit

class TabBarViewController: UITabBarController {
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.borderColor()
        
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let walletViewController = WalletViewController()
        let settingsViewController = SettingsViewController()
        
        viewControllers = [walletViewController, settingsViewController]
        
        viewControllers?.forEach({
            $0.loadViewIfNeeded()
            update(viewController: $0)
        })
        
        tabBar.tintColor = R.color.textPrimary()
        tabBar.unselectedItemTintColor = R.color.textSecond()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSeparator()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            viewControllers?.forEach { update(viewController: $0) }
        }
    }
    
    private func setupSeparator() {
        tabBar.backgroundColor = R.color.bgPrimary()
        tabBar.addSubview(separatorView)

        separatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }
    
    private func update(viewController: UIViewController) {
        switch viewController {
        case is WalletViewController:
            viewController.tabBarItem = UITabBarItem(
                title: localizable.tabBarWallet(),
                image: R.image.tabWallet(),
                selectedImage: R.image.tabWalletSelected()
            )
            
        case is SettingsViewController:
            viewController.tabBarItem = UITabBarItem(
                title: localizable.tabBarSettings(),
                image: R.image.tabSettings(),
                selectedImage: R.image.tabSettingsSelected()
            )
            
        default: break
        }
        
        viewController.tabBarItem.setTitleTextAttributes([
            .font : UIFont.interFont(ofSize: 12, weight: .semiBold)
        ], for: .normal)
    }
}
