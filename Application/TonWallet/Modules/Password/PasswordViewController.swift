import UIKit
import LocalAuthentication

class PasswordViewController: UIViewController {
    
    enum ViewType {
        case create
        case check
        case login
    }
    
    var successHandler: ((String) -> Void)?
    
    private let type: ViewType
    private var userPassword: String = ""
    private var incorrectCount: Int = 0
    private var blockSeconds: Int = 30
    private var isPasswordSetted: Bool = false
    private var isAnimating: Bool = false
    
    private let userSettings = UserSettings.shared
    private var blockTimer: Timer = .init()
    private let selectionFeedback: UISelectionFeedbackGenerator = .init()
    private let notificationFeedback: UINotificationFeedbackGenerator = .init()
    
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
        case .check, .login:
            userPassword = KeychainManager().getPassword() ?? ""
            isPasswordSetted = true
            
        case .create:
            userPassword = ""
            isPasswordSetted = false
        }
        
        mainView.setupContent(with: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.textField.delegate = self
        mainView.textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        mainView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        checkBlockTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkBiometry()
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
    
    @objc private func closeButtonTapped() {
        switch type {
        case .check:
            dismiss(animated: true)
            
        case .login:
            WalletManager.shared.wallets.forEach { wallet in
                KeychainManager().deleteKeys(for: wallet.id)
                KeychainManager().deleteMnemonics(for: wallet.id)
            }
            KeychainManager().deletePassword()
            
            RootNavigationController.shared.setViewControllers([CreateViewController()], animated: true)
            
        default:
            break
        }
    }
    
    @objc func willEnterForeground() {
        checkBlockTimer()
    }
    
    // MARK: - Private methods
    
    private func checkBiometry() {
        if userSettings.biometryEnabled {
            evaluatePolicy { [weak self] success, error in
                guard let self = self else { return }

                if success {
                    print("Biometric authentication succeeded")
                } else {
                    if let error = error {
                        print("Biometric authentication failed with error: \(error.localizedDescription)")
                    } else {
                        print("Biometric authentication failed")
                    }
                }
            }
        } else {
            self.mainView.textField.becomeFirstResponder()
        }
    }
    
    private func checkPassword() {
        if isPasswordSetted {
            if userPassword == mainView.textField.text ?? "" {
                mainView.textField.resignFirstResponder()
                notificationFeedback.notificationOccurred(.success)
                
                successHandler?(userPassword)
            } else {
                notificationFeedback.notificationOccurred(.error)
                mainView.textField.text = nil
                
                switch type {
                case .create:
                    userPassword = ""
                    isPasswordSetted = false
                    animateIncorrectPassword(needToSet: type == .create)
                    
                case .check, .login:
                    incorrectCount += 1
                    
                    if incorrectCount == 3 {
                        handleBlock()
                    } else {
                        animateIncorrectPassword(needToSet: type == .create)
                    }
                }
            }
        } else {
            mainView.textField.text = nil
            isPasswordSetted = true
            
            animateReset(with: localizable.passwordRepeatTitle())
        }
    }
    
    private func checkBlockTimer() {
        blockTimer.invalidate()
        
        if let startTime = userSettings.blockDate {
            let timeInterval = Date().timeIntervalSince(startTime)
            blockSeconds = Int(30.0 - timeInterval)
            setupTimer()
            
            if blockSeconds > 0 {
                incorrectCount = 3
                mainView.setBlockContent(blockSeconds: blockSeconds.description)
            }
        }
    }
    
    private func animateReset(with title: String) {
        isAnimating = true
        
        UIView.transition(with: mainView.titleLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.mainView.titleLabel.text = title
        }
        
        UIView.transition(with: mainView.indicatorsView, duration: 0.3, options: .transitionCrossDissolve) {
            self.mainView.indicatorsView.setAllIndicators(to: .off)
        } completion: { _ in
            self.isAnimating = false
        }
    }
    
    private func animateIncorrectPassword(needToSet: Bool) {
        let title = needToSet ? localizable.passwordSetTitle() : localizable.passwordEnterTitle()
        isAnimating = true
        
        mainView.indicatorsView.shake()
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
            self.mainView.indicatorsView.setAllIndicators(to: .error)
        } completion: { _ in
            guard self.isAnimating else {
                self.mainView.titleLabel.text = title
                return
            }
            
            UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseInOut) {
                self.mainView.indicatorsView.setAllIndicators(to: .off)
            } completion: { _ in
                self.isAnimating = false
                UIView.transition(with: self.mainView.titleLabel, duration: 0.3, options: .transitionCrossDissolve) {
                    self.mainView.titleLabel.text = title
                }
            }
        }
    }
    
    private func handleBlock() {
        userSettings.blockDate = Date()
        mainView.setBlockContent(blockSeconds: blockSeconds.description)
        setupTimer()
    }
    
    private func setupTimer() {
        blockTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            
            if self.blockSeconds <= 0 {
                self.blockSeconds = 30
                self.incorrectCount = 0
                self.userSettings.blockDate = nil
                self.mainView.indicatorsView.setAllIndicators(to: .off)
                self.mainView.titleLabel.text = localizable.passwordEnterTitle()
                self.mainView.setSubtitle(text: localizable.passwordEnterSubtitle())
                self.mainView.imageView.alpha = 1
                timer.invalidate()
            } else {
                self.blockSeconds -= 1
                let seconds = self.blockSeconds.description
                let text = localizable.passwordBlockSubtitle(seconds)
                
                self.mainView.setSubtitle(text: text)
            }
        })
    }
    
    private func evaluatePolicy(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access the app"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, error)
                    }
                }
            }
        } else {
            completion(false, error)
        }
    }

}

// MARK: - UITextFieldDelegate

extension PasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard
            let safeText = textField.text,
            safeText.count < 4 || string == "",
            incorrectCount < 3
        else { return false }
        
        if safeText.isEmpty && isAnimating {
            isAnimating = false
            mainView.layer.removeAllAnimations()
            mainView.indicatorsView.setAllIndicators(to: .off)
        }
        
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
