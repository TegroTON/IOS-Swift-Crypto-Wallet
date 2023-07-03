import UIKit

class ToastNotificationView: UIView { }
class ToastWindow: UIWindow {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        let hitView = super.hitTest(point, with: event)

        if !(hitView?.isKind(of: ToastNotificationView.self) ?? false) {
            return nil
        }

        return hitView
    }
}

class ToastController: UIViewController {
    var titleString = ""
    var duration: TimeInterval = 0
    var backgroundColor: UIColor = .black
    var textColor: UIColor = .white
    var popupWindow: ToastWindow?
    var notificationView = ToastNotificationView()
    var hideTimer: Timer = .init()
    
    private static let shared = ToastController()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @discardableResult
    static func showNotification(title: String, duration: TimeInterval = 3.0, backgroundColor: UIColor? = .black, textColor: UIColor? = .white) -> ToastController {
        let notification = ToastController.shared.initNotification(title: title, duration: duration, backgroundColor: backgroundColor, textColor: textColor)
        
        if notification.popupWindow == nil {
            notification.generateNotificationView()
            notification.view.layoutIfNeeded()
            
            notification.show()
        } else {
            notification.show(isExisting: true)
        }
        
        return notification
    }
    
    // MARK: - Private actions
    
    @objc private func eventHandler() {
        gestureToHideUp()
    }
    
    @objc private func gestureToHideUp() {
        hide(force: false, direction: 0)
    }
    
    @objc private func gestureToHideLeft() {
        hide(force: false, direction: 2)
    }
    
    @objc private func gestureToHideRight() {
        hide(force: false, direction: 1)
    }
    
    @objc private func gestureToTap() {
        hide(force: false, direction: 0)
    }
    
    // MARK: - Private mathods
    
    private func generateNotificationView() {
        popupWindow = ToastWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
        
//        popupWindow?.backgroundColor = .red.withAlphaComponent(0.3)
        popupWindow?.backgroundColor = .clear
        popupWindow?.windowLevel = UIWindow.Level.statusBar + 1
        popupWindow?.rootViewController = self
        popupWindow?.isHidden = false
        
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .clear
        
        notificationView = ToastNotificationView()
        notificationView.backgroundColor = backgroundColor
        notificationView.layer.cornerRadius = 8.0
        notificationView.layer.shadowColor = UIColor.black.cgColor
        notificationView.layer.shadowOffset = CGSize(width: 0, height: 4)
        notificationView.layer.shadowRadius = 6.0
        notificationView.layer.shadowOpacity = 0.2
        
        view.addSubview(notificationView)
        
        notificationView.addSubview(titleLabel)
        
        setupConstraints()
        
        // Gestures
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(gestureToHideRight))
        swipeGestureRight.direction = .right
        notificationView.addGestureRecognizer(swipeGestureRight)
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(gestureToHideLeft))
        swipeGestureLeft.direction = .left
        notificationView.addGestureRecognizer(swipeGestureLeft)
        
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(gestureToHideUp))
        swipeGestureUp.direction = .up
        notificationView.addGestureRecognizer(swipeGestureUp)
        
        // Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureToTap))
        notificationView.addGestureRecognizer(tapGesture)
    }
    
    private func initNotification(title: String, duration: TimeInterval, backgroundColor: UIColor?, textColor: UIColor?) -> ToastController {
        titleString = title
        self.duration = duration
        
        if let backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        if let textColor {
            self.textColor = textColor
        }
        
        return self
    }
    
    private func show(isExisting: Bool = false) {
        DispatchQueue.main.async {
            self.showInRootView(isExisting: isExisting)
        }
    }
    
    private func showInRootView(isExisting: Bool) {
        if isExisting {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn) {
                self.notificationView.transform = .init(translationX: 0, y: 15.0)
            } completion: { _ in
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
                    self.titleLabel.textColor = self.textColor
                    self.notificationView.backgroundColor = self.backgroundColor
                    self.notificationView.transform = .identity
                }
            }
            
            if titleLabel.text != titleString {
                UIView.transition(with: titleLabel, duration: 0.3, options: .transitionCrossDissolve) {
                    self.titleLabel.text = self.titleString
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            notificationView.backgroundColor = backgroundColor
            titleLabel.textColor = textColor
            titleLabel.text = titleString
            
            setShowConstraints()
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        setupTimer()
    }
    
    private func setupTimer() {
        hideTimer.invalidate()
        
        hideTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { _ in
            self.hide(force: true)
        })
    }
    
    private func hide(force: Bool, direction: Int = 0) {
        if force {
            forceHideInRootView()
        } else {
            hideInRootView(direction)
        }
    }
    
    private func hideInRootView(_ direction: Int) {
        RunLoop.cancelPreviousPerformRequests(withTarget: self)
        
        if direction == 0 {
            setHideConstraints()
        }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            if direction == 0 {
                self.view.layoutIfNeeded()
            }
            
            if direction == 1 {
                self.notificationView.transform = .init(translationX: self.notificationView.bounds.size.width, y: 0)
            }
            
            if direction == 2 {
                self.notificationView.transform = .init(translationX: -self.notificationView.bounds.size.width, y: 0)
            }
        }) { _ in
            self.popupWindow?.rootViewController = nil
            self.popupWindow = nil
            self.view.removeFromSuperview()
            
            if direction != 0 {
                self.notificationView.transform = .identity
                self.setHideConstraints()
            }

        }
    }
    
    private func forceHideInRootView() {
        RunLoop.cancelPreviousPerformRequests(withTarget: self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.notificationView.alpha = 0
        }, completion: {_ in
            self.popupWindow?.rootViewController = nil
            self.popupWindow = nil
            self.view.removeFromSuperview()
        })
    }
    
    private func setShowConstraints() {
        notificationView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(24.0)
        }
    }
    
    private func setHideConstraints() {
        notificationView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(24.0)
            make.bottom.equalTo(view.snp.top)
        }
    }
    
    private func setupConstraints() {
        notificationView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(24.0)
            make.bottom.equalTo(view.snp.top)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(18.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
    }

}
