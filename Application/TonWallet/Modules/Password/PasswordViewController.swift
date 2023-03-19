import UIKit

class PasswordViewController: UIViewController {
    
    private var userPassword: String = ""
    private var isPasswordSetted: Bool = false
    private var keyboardHeight: CGFloat = 0
    private var isButtonHidden: Bool = true
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    var mainView: PasswordView {
        return view as! PasswordView
    }
    
    override func loadView() {
        view = PasswordView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.textField.delegate = self
        mainView.textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.textField.becomeFirstResponder()
    }
    
    // MARK: - Private actions
    
    @objc private func keyboardFrameChanged(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        keyboardHeight = frame.cgRectValue.height
    }
    
    @objc private func textFieldDidChanged(_ sender: UITextField) {
        let safeText = sender.text ?? ""
        selectionFeedback.selectionChanged()
        
        if safeText.count < 5 {
            if safeText.count == 4 {
                if !isPasswordSetted {
                    userPassword = safeText
                }
                
                checkPassword()
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private methods
    
    private func animateReset(with title: String) {
        UIView.transition(with: mainView.titleLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.mainView.titleLabel.text = title
        }
        
        UIView.transition(with: mainView.indicatorsView, duration: 0.3, options: .transitionCrossDissolve) {
            self.mainView.indicatorsView.turnOffIndicators()
        }
    }
    
    private func animateIncorrectPassword(needToSet: Bool) {
        let title = needToSet ? R.string.localizable.passwordSetTitle() : R.string.localizable.passwordEnterTitle()
        
        mainView.indicatorsView.animateRedIndicators()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.animateReset(with: title)
        }
    }
    
    private func checkPassword() {
        if isPasswordSetted {
            if userPassword == mainView.textField.text ?? "" {
                mainView.textField.resignFirstResponder()
                notificationFeedback.notificationOccurred(.success)
                
                KeychainManager().storePassword(userPassword) { success in
                    if success {
                        print("💙 success store password")
                    } else {
                        print("❤️ failure store password")
                    }
                }
                
                let vc = SuccessViewController()
                vc.modalPresentationStyle = .overFullScreen
                
                present(vc, animated: false) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
                    }
                }
            } else {
                userPassword = ""
                mainView.textField.text = nil
                isPasswordSetted = false
                
                notificationFeedback.notificationOccurred(.error)
                animateIncorrectPassword(needToSet: true)
            }
        } else {
            mainView.textField.text = nil
            isPasswordSetted = true
            
            let title = R.string.localizable.passwordRepeatTitle()
            
            animateReset(with: title)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension PasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let safeText = textField.text ?? ""
        guard safeText.count < 4 || string == "" else { return false }
        
        if string == "" {
            UIView.animate(withDuration: 0.15) {
                self.mainView.indicatorsView.changeIndicator(isOn: false, index: safeText.count - 1, animate: false)
            }
        } else {
            mainView.indicatorsView.changeIndicator(isOn: true, index: safeText.count, animate: true)
        }
        
        return true
    }
}
