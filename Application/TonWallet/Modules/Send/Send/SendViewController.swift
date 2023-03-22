import UIKit

class SendViewController: UIViewController {

    let generator = UISelectionFeedbackGenerator()
    
    var mainView: SendView {
        return view as! SendView
    }
    
    override func loadView() {
        view = SendView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTargets()
        setupGestures()
        setupObservers()
    }

    // MARK: - Private actions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func sendButtonTapped() {
        let address = mainView.formView.addressTextField.text ?? ""
        let amount = Double(mainView.formView.amountTextField.text ?? "") ?? 0.0
        let commission = 0.00551003
        let model = ConfirmDetailsModel(address: address, amount: amount, commission: commission, token: "TON")
        
        navigationController?.pushViewController(SendConfirmViewController(model: model), animated: true)
    }
    
    @objc private func balanceViewTapped() {
        // TODO: Нужно заполнить поле суммы балансом
        generator.selectionChanged()
    }
    
    @objc private func tokenViewTapped() {
        // TODO: Нужно вызвать модалку выбора токенов
        generator.selectionChanged()
    }
    
    @objc private func scanViewTapped() {
        // TODO: Нужно вызвать модалку сканирования qr
        generator.selectionChanged()
    }
    
    @objc private func pasteViewTapped() {
        mainView.formView.addressTextField.text = UIPasteboard.general.string
        addressFieldChanged(mainView.formView.addressTextField)
        generator.selectionChanged()
    }
    
    @objc private func viewTapped() {
        mainView.endEditing(true)
    }
    
    @objc private func addressFieldChanged(_ sender: TextField) {
        //TODO: надо добавить таймер, чтобы через некоторое время проверять корректность адреса
        
        let isHidden = sender.text?.isEmpty == false
        let rightInset = isHidden ? 16.0 : 90.0
        
        sender.contentInset.right = rightInset
        mainView.formView.scanContainer.isHidden = isHidden
        mainView.formView.pasteContainer.isHidden = isHidden
        
        updateAvailableState()
    }
    
    @objc private func amountFieldChanged(_ sender: TextField) {
        updateAvailableState()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        else { return }
        
        let option = UIView.AnimationOptions(rawValue: curve.uintValue)
        let duration = animationDuration.doubleValue
        let height = keyboardFrame.cgRectValue.height
        
        mainView.sendButtonBottomConstraint.update(offset: -height + 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: option, animations: {
            self.mainView.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        else { return }
        
        let option = UIView.AnimationOptions(rawValue: curve.uintValue)
        let duration = animationDuration.doubleValue
        
        mainView.sendButtonBottomConstraint.update(offset: 0)
        
        UIView.animate(withDuration: duration, delay: 0, options: option, animations: {
            self.mainView.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Private methods
    
    private func setupTargets() {
        mainView.headerView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        mainView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        mainView.formView.addressTextField.addTarget(self, action: #selector(addressFieldChanged), for: .editingChanged)
        mainView.formView.amountTextField.addTarget(self, action: #selector(amountFieldChanged), for: .editingChanged)
    }
    
    private func setupGestures() {
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        let tokenGesture = UITapGestureRecognizer(target: self, action: #selector(tokenViewTapped))
        let scanGesture = UITapGestureRecognizer(target: self, action: #selector(scanViewTapped))
        let pasteGesture = UITapGestureRecognizer(target: self, action: #selector(pasteViewTapped))
        let balanceGesture = UITapGestureRecognizer(target: self, action: #selector(balanceViewTapped))
        
        mainView.addGestureRecognizer(viewGesture)
        mainView.formView.tokenView.addGestureRecognizer(tokenGesture)
        mainView.formView.scanContainer.addGestureRecognizer(scanGesture)
        mainView.formView.pasteContainer.addGestureRecognizer(pasteGesture)
        mainView.formView.balanceContainer.addGestureRecognizer(balanceGesture)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func updateAvailableState() {
        let addressIsEmpty = mainView.formView.addressTextField.text?.isEmpty == true
        let amountIsEmpty = mainView.formView.amountTextField.text?.isEmpty == true
        
        if !addressIsEmpty && !amountIsEmpty {
            guard mainView.sendButton.isEnabled == false else { return }
            mainView.sendButton.isEnabled = true
            
            UIView.animate(withDuration: 0.3) {
                self.mainView.sendButton.backgroundColor = .init(hex6: 0x0066FF)
                self.mainView.sendButton.setTitleColor(.white, for: .normal)
            }
        } else {
            guard mainView.sendButton.isEnabled == true else { return }
            mainView.sendButton.isEnabled = false
            
            UIView.animate(withDuration: 0.3) {
                self.mainView.sendButton.backgroundColor = R.color.btnSecond()
                self.mainView.sendButton.setTitleColor(R.color.textSecond(), for: .normal)
            }
        }
    }
}
