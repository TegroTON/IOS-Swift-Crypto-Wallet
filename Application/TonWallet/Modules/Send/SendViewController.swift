import UIKit

class SendViewController: UIViewController {

    var mainView: SendView {
        return view as! SendView
    }
    
    override func loadView() {
        view = SendView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.headerView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    // MARK: - Private actions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func balanceViewTapped() {
        // TODO: Нужно заполнить филд балансом
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    @objc private func tokenViewTapped() {
        // TODO: Нужно вызвать модалку выбора токенов
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    @objc private func scanViewTapped() {
        // TODO: Нужно вызвать модалку сканирования qr
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    @objc private func pasteViewTapped() {
        // TODO: Нужно вставить адрес
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    @objc private func viewTapped() {
        mainView.endEditing(true)
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
        
        mainView.sendButtonBottomConstraint.update(offset: -mainView.safeAreaInsets.bottom - 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: option, animations: {
            self.mainView.layoutIfNeeded()
        }, completion: nil)
    }
    
}
