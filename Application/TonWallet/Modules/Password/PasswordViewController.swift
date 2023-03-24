import UIKit

class PasswordViewController: UIViewController {
    
    enum ViewType {
        case set
        case check
    }
    
    var completionHandler: ((String) -> Void)?
    
    private let type: ViewType
    private var userPassword: String = ""
    private var isPasswordSetted: Bool = false
    private var isAnimating = false
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    var mainView: PasswordView {
        return view as! PasswordView
    }
    
    override func loadView() {
        view = PasswordView()
    }
    
    init(type: ViewType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        
        switch type {
        case .check:
            userPassword = KeychainManager().getPassword() ?? ""
            isPasswordSetted = true
            
            mainView.backButton.isHidden = true
            mainView.setSubtitle(text: R.string.localizable.passwordEnterSubtitle())
            mainView.titleLabel.text = R.string.localizable.passwordEnterTitle()
            
        case .set:
            userPassword = ""
            isPasswordSetted = false
            
            mainView.backButton.isHidden = false
            mainView.setSubtitle(text: R.string.localizable.passwordSubtitle())
            mainView.titleLabel.text = R.string.localizable.passwordSetTitle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.textField.delegate = self
        mainView.textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.textField.becomeFirstResponder()
    }
    
    // MARK: - Private actions
    
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
    
    private func checkPassword() {
        if isPasswordSetted {
            if userPassword == mainView.textField.text ?? "" {
                mainView.textField.resignFirstResponder()
                notificationFeedback.notificationOccurred(.success)
                
                completionHandler?(userPassword)
            } else {
                if type == .set {
                    userPassword = ""
                    isPasswordSetted = false
                }
                
                mainView.textField.text = nil
                
                notificationFeedback.notificationOccurred(.error)
                animateIncorrectPassword(needToSet: type == .set)
            }
        } else {
            mainView.textField.text = nil
            isPasswordSetted = true
            
            animateReset(with: R.string.localizable.passwordRepeatTitle())
        }
    }
    
    private func animateReset(with title: String) {
        isAnimating = true
        
        UIView.transition(with: mainView.titleLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.mainView.titleLabel.text = title
        }

        UIView.transition(with: mainView.indicatorsView, duration: 0.3, options: .transitionCrossDissolve) {
            self.mainView.indicatorsView.setIndicators(to: .off)
        } completion: { _ in
            self.isAnimating = false
        }
    }
    
    private func animateIncorrectPassword(needToSet: Bool) {
        let title = needToSet ? R.string.localizable.passwordSetTitle() : R.string.localizable.passwordEnterTitle()
        isAnimating = true
        
        mainView.indicatorsView.shake()
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
            self.mainView.indicatorsView.setIndicators(to: .error)
        } completion: { _ in
            guard self.isAnimating else {
                self.mainView.titleLabel.text = title
                return
            }
            
            UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseInOut) {
                self.mainView.indicatorsView.setIndicators(to: .off)
            } completion: { _ in
                self.isAnimating = false
                UIView.transition(with: self.mainView.titleLabel, duration: 0.3, options: .transitionCrossDissolve) {
                    self.mainView.titleLabel.text = title
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension PasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let safeText = textField.text ?? ""
        
        if safeText.isEmpty && isAnimating {
            isAnimating = false
            mainView.layer.removeAllAnimations()
            mainView.indicatorsView.setIndicators(to: .off)
        }
        
        guard safeText.count < 4 || string == "" else { return false }
        
        if string == "" {
            UIView.animate(withDuration: 0.15) {
                self.mainView.indicatorsView.setOn(false, indicator: safeText.count - 1, animate: false)
            }
        } else {
            mainView.indicatorsView.setOn(true, indicator: safeText.count, animate: true)
        }
        
        return true
    }
}
