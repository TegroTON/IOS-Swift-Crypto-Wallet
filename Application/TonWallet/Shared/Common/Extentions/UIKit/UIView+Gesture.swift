import UIKit

extension UIView {
    func addTapGesture(target: Any?, action: Selector?) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(gesture)
    }
}
