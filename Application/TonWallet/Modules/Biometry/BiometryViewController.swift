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
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access the app"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        UserSettings.shared.biometryEnabled = true
                    } else {
                        UserSettings.shared.biometryEnabled = false
                    }
                    
                    self.dismiss(animated: true)
                }
            }
            
        } else {
            UserSettings.shared.biometryEnabled = false
            dismiss(animated: true)
        }
    }
    
}
