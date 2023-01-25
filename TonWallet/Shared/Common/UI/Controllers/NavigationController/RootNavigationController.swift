import UIKit

class RootNavigationController: UINavigationController {

    static let shared = RootNavigationController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        
        setup()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        interactivePopGestureRecognizer?.isEnabled = true
        navigationBar.isHidden = true
        modalPresentationStyle = .fullScreen
    }
    
}
