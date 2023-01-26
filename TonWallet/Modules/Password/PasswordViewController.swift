import UIKit

class PasswordViewController: UIViewController {
    
    var userPassword = ""
    
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
    
    @objc private func keyboardFrameChanged(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let rect = frame.cgRectValue
        let height = rect.height
        
        mainView.nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(78.0)
            make.height.equalTo(48.0)
            make.bottom.equalToSuperview().offset(-33 - height)
        }
        
        mainView.layoutIfNeeded()
    }
    
    @objc private func textFieldDidChanged(_ sender: UITextField) {
        let safeText = sender.text ?? ""
        
        if safeText.count < 5 {
            userPassword = sender.text ?? ""
            
            if safeText.count == 4 {
                UIView.animate(withDuration: 0.3) {
                    self.mainView.nextButton.alpha = 1
                }
            } else {
                mainView.nextButton.alpha = 0
            }
        }
        
        print(userPassword)
    }
    
    @objc private func nextButtonTapped() {
    }
    
}

// MARK: - UITextFieldDelegate

extension PasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let safeText = textField.text ?? ""
        guard safeText.count < 4 || string == "" else { return false }
        
        if string == "" {
            UIView.animate(withDuration: 0.15) {
                if safeText.count == 4 {
                    self.mainView.indicatorsView.fourthView.backgroundColor = R.color.passwordIndicator()
                    self.mainView.indicatorsView.fourthView.layer.borderWidth = 1
                } else if safeText.count == 3 {
                    self.mainView.indicatorsView.thirdView.backgroundColor = R.color.passwordIndicator()
                    self.mainView.indicatorsView.thirdView.layer.borderWidth = 1
                } else if safeText.count == 2 {
                    self.mainView.indicatorsView.secondView.backgroundColor = R.color.passwordIndicator()
                    self.mainView.indicatorsView.secondView.layer.borderWidth = 1
                } else if safeText.count == 1 {
                    self.mainView.indicatorsView.firstView.backgroundColor = R.color.passwordIndicator()
                    self.mainView.indicatorsView.firstView.layer.borderWidth = 1
                }
            }
        } else {
            if safeText.count == 0 {
                self.mainView.indicatorsView.firstView.backgroundColor = .init(hex6: 0x4285F4)
                self.mainView.indicatorsView.firstView.layer.borderWidth = 0
            } else if safeText.count == 1 {
                self.mainView.indicatorsView.secondView.backgroundColor = .init(hex6: 0x4285F4)
                self.mainView.indicatorsView.secondView.layer.borderWidth = 0
            } else if safeText.count == 2 {
                self.mainView.indicatorsView.thirdView.backgroundColor = .init(hex6: 0x4285F4)
                self.mainView.indicatorsView.thirdView.layer.borderWidth = 0
            } else if safeText.count == 3 {
                self.mainView.indicatorsView.fourthView.backgroundColor = .init(hex6: 0x4285F4)
                self.mainView.indicatorsView.fourthView.layer.borderWidth = 0
            }
        }
        
        return true
    }
}
