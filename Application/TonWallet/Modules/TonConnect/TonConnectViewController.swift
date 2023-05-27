import UIKit

class TonConnectViewController: UIViewController {

    private var model: ConnectQuery
    private let provider: TonConnectProvider = .init()
    
    private var mainView: TonConnectView { view as! TonConnectView }
    override func loadView() { view = TonConnectView() }
    
    init(model: ConnectQuery) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestManifest()
    }

    // MARK: - Private methods
    
    private func requestManifest() {
        
    }
}
