import UIKit

class ReceiveViewController: UIViewController {
    
    var mainView: ReceiveView {
        return view as! ReceiveView
    }
    
    override func loadView() {
        view = ReceiveView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.headerView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
