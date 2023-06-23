import UIKit
import LocalAuthentication

class BiometryViewController: ModalScrollViewController {
    
    var disappearHandler: (() -> Void)?
    
    private var mainView: BiometryView { modalView as! BiometryView }
    override func loadModalView() { modalView = BiometryView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.enableButton.addTarget(self, action: #selector(enableButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disappearHandler?()
    }
    
    @objc private func enableButtonTapped() {
        UserSettings.shared.biometryEnabled = true
        self.dismiss(animated: true)
    }
    
}
