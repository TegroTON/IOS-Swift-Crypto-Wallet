import UIKit
import LocalAuthentication

class PasswordViewController: UIViewController {
    
    enum ViewType {
        case create
        case check
        case login
        case change
    }
    
    var successHandler: ((String) -> Void)?
    
    private var userPassword: String = ""
    private var incorrectCount: Int = 0
    private var blockSeconds: Int = 30
    private var isPasswordSetted: Bool = false
    private var isAnimating: Bool = false
    
    private let userSettings = UserSettings.shared
    private var blockTimer: Timer = .init()
    private let selectionFeedback: UISelectionFeedbackGenerator = .init()
    private let notificationFeedback: UINotificationFeedbackGenerator = .init()
    
    private var type: ViewType = .login {
        didSet {
            mainView.setupContent(with: type)
        }
    }
    
    private var mainView: PasswordView { view as! PasswordView }
    override func loadView() { view = PasswordView() }
    
    init(type: ViewType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
        
        switch type {
        case .check, .login:
            userPassword = KeychainManager().getPassword() ?? ""
            isPasswordSetted = true
            
        case .create:
            userPassword = ""
            isPasswordSetted = false
            
        case .change:
            userPassword = KeychainManager().getPassword() ?? ""
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
        
        activateKeyboard()
    }
    
    // MARK: - Private actions
    
    @objc private func textFieldDidChanged(_ sender: UITextField) {
        let safeText = sender.text ?? ""
        selectionFeedback.selectionChanged()
        
        if safeText.count < 5 {
            if safeText.count == 4 {
                checkPassword(safeText)
            }
        }
    }
    
    @objc private func backButtonTapped() {
        closeScreen()
    }
    
    @objc private func closeButtonTapped() {
        switch type {
        case .check, .change:
            closeScreen()
        case .login:
            logout()
        default:
            break
        }
    }
    
    @objc func willEnterForeground() {
        checkBlockTimer()
    }
    
    // MARK: - Private methods
    
    private func activateKeyboard() {
        mainView.textField.becomeFirstResponder()
        
        switch type {
        case .login, .check:
            checkBiometry()
            
        default:
            break
        }
    }
    
    private func checkBiometry() {
        if userSettings.biometryEnabled {
            evaluatePolicy { [weak self] success, error in
                guard let self = self else { return }
                
                if success {
                    successHandler?(userPassword)
                }
            }
        }
    }
    
    private func checkPassword(_ password: String) {
        switch type {
        case .create:
            checkNewPassword(password)
        case .login, .check:
            if userPassword == password {
                mainView.textField.resignFirstResponder()
                notificationFeedback.notificationOccurred(.success)
                
                successHandler?(userPassword)
            } else {
                notificationFeedback.notificationOccurred(.error)
                mainView.textField.text = nil
                incorrectCount += 1
                
                if incorrectCount == 3 {
                    handleBlock()
                } else {
                    animateIncorrectPassword()
                }
            }
        case .change:
            if !userPassword.isEmpty && !isPasswordSetted {
                if userPassword == password {
                    userPassword = ""
                    mainView.textField.text = nil
                    animateReset(with: localizable.passwordNewTitle(), subtitle: localizable.passwordNewSubtitle())
                    notificationFeedback.notificationOccurred(.success)
                } else {
                    notificationFeedback.notificationOccurred(.error)
                    mainView.textField.text = nil
                    animateIncorrectPassword()
                }
            } else {
                checkNewPassword(password)
            }
        }
    }
    
    private func checkNewPassword(_ password: String) {
        if isPasswordSetted {
            if userPassword == password {
                mainView.textField.resignFirstResponder()
                notificationFeedback.notificationOccurred(.success)
                successHandler?(userPassword)
            } else {
                notificationFeedback.notificationOccurred(.error)
                isPasswordSetted = false
                userPassword = ""
                mainView.textField.text = nil
                
                
                switch type {
                case .create:
                    animateIncorrectPassword(resetTitle: localizable.passwordCreateTitle())
                    
                case .change:
                    animateIncorrectPassword(resetTitle: localizable.passwordNewTitle())
                    
                default: break
                }
            }
        } else {
            isPasswordSetted = true
            userPassword = password
            mainView.textField.text = nil
            animateReset(with: localizable.passwordRepeatTitle())
        }
    }
    
    private func animateReset(with title: String, subtitle: String? = nil) {
        isAnimating = true
        
        
        UIView.transition(with: mainView.titleLabel, duration: 0.3, options: .transitionFlipFromRight) {
            self.mainView.titleLabel.text = title
        }
        
        if let subtitle = subtitle {
            UIView.transition(with: mainView.subtitleLabel, duration: 0.3, options: .transitionFlipFromRight) {
                self.mainView.setSubtitle(text: subtitle)
            }
        }
        
        UIView.transition(with: mainView.indicatorsView, duration: 0.3, options: .transitionCrossDissolve) {
            self.mainView.indicatorsView.setAllIndicators(to: .off)
        } completion: { _ in
            self.isAnimating = false
        }
    }
    
    private func animateIncorrectPassword(resetTitle: String? = nil) {
        isAnimating = true
        mainView.indicatorsView.shake()
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
            self.mainView.indicatorsView.setAllIndicators(to: .error)
        } completion: { _ in
            guard self.isAnimating else {
                if let resetTitle = resetTitle {
                    self.mainView.titleLabel.text = resetTitle
                }
                return
            }
            
            UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseInOut) {
                self.mainView.indicatorsView.setAllIndicators(to: .off)
            } completion: { _ in
                self.isAnimating = false
                if let resetTitle = resetTitle {
                    UIView.transition(with: self.mainView.titleLabel, duration: 0.3, options: .transitionFlipFromLeft) {
                        self.mainView.titleLabel.text = resetTitle
                    }
                }
            }
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
                self.mainView.setupContent(with: type)
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
    
    private func logout() {
        let alert = UIAlertController(
            title: localizable.settingsLogoutAlertTitle(),
            message: localizable.settingsLogoutAlertMessage(),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: localizable.settingsLogoutAlertCancel(), style: .cancel)
        let logoutAction = UIAlertAction(title: localizable.settingsLogout(), style: .destructive) { _ in
            UserSettings.shared.logout()
            
            for wallet in WalletManager.shared.wallets {
                KeychainManager().deleteMnemonics(for: wallet.id)
                KeychainManager().deleteKeys(for: wallet.id)
            }
            KeychainManager().deletePassword()
            
            RootNavigationController.shared.setViewControllers([CreateViewController()], animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        
        present(alert, animated: true)
    }

    private func closeScreen() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
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
