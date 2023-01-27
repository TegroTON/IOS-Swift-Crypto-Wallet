import UIKit

class PasswordViewController: UIViewController {
    
    var userPassword: String = ""
    var isPasswordSetted: Bool = false
    var keyboardHeight: CGFloat = 0
    var isButtonHidden: Bool = true
    
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
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.textField.becomeFirstResponder()
    }
    
    // MARK: - Action mehtods
    
    @objc private func keyboardFrameChanged(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        keyboardHeight = frame.cgRectValue.height
    }
    
    @objc private func textFieldDidChanged(_ sender: UITextField) {
        let safeText = sender.text ?? ""
        
        if safeText.count < 5 {
            if safeText.count == 4 {
                moveNextButton(needShow: true)
                
                if !isPasswordSetted {
                    userPassword = safeText
                }
            } else {
                moveNextButton(needShow: false)
            }
        }
    }
    
    @objc private func nextButtonTapped() {
        if isPasswordSetted {
            if userPassword == mainView.textField.text ?? "" {
                mainView.textField.resignFirstResponder()
                
                let vc = SuccessViewController()
                vc.modalPresentationStyle = .overFullScreen
                
                present(vc, animated: false) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.navigationController?.pushViewController(MainViewController(), animated: false)
                    }
                }
            } else {
                userPassword = ""
                mainView.textField.text = nil
                isPasswordSetted = false
                
                animateIncorrectPassword(needToSet: true)
            }
        } else {
            mainView.textField.text = nil
            isPasswordSetted = true
            
            let title = R.string.localizable.passwordConfirmTitle()
            let subtitle = R.string.localizable.passwordConfirmSubtitle()
            
            animateReset(with: title, subtitle: subtitle)
        }
    }
    
    // MARK: - Private methods
    
    private func animateReset(with title: String, subtitle: String) {
        UIView.transition(with: mainView.titleLabel, duration: 0.3, options: .transitionFlipFromRight) {
            self.mainView.titleLabel.text = title
        }
        
        UIView.transition(with: mainView.subtitleLabel, duration: 0.3, options: .transitionFlipFromRight) {
            self.mainView.setSubtitle(text: subtitle)
        }
        
        UIView.transition(with: mainView.indicatorsView, duration: 0.3, options: .transitionFlipFromRight) {
            self.mainView.indicatorsView.turnOffIndicators()
        }
        
        moveNextButton(needShow: false)
    }
    
    private func animateIncorrectPassword(needToSet: Bool) {
        let title = needToSet ? R.string.localizable.passwordSetTitle() : R.string.localizable.passwordEnterTitle()
        let subtitle = needToSet ? R.string.localizable.passwordSetSubtitle() : R.string.localizable.passwordEnterSubtitle()
        
        mainView.indicatorsView.animateRedIndicators()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.animateReset(with: title, subtitle: subtitle)
            self.moveNextButton(needShow: false)
        }
    }
    
    private func moveNextButton(needShow: Bool) {
        let offset = needShow ? -33 - keyboardHeight : 48
        
        mainView.nextButton.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(78.0)
            make.height.equalTo(48.0)
            make.bottom.equalToSuperview().offset(offset)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.mainView.layoutIfNeeded()
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
                self.mainView.indicatorsView.changeIndicator(isOn: false, index: safeText.count - 1)
            }
        } else {
            mainView.indicatorsView.changeIndicator(isOn: true, index: safeText.count)
        }
        
        return true
    }
}
