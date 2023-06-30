import UIKit
import SnapKit

class LoadAnimateView: RootView {

    let color: UIColor = .init(hex6: 0x0066FF)
    
    let firstBallView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex6: 0x0066FF)
        view.layer.cornerRadius = 16/2
        
        return view
    }()
    
    let secondBallView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex6: 0x0066FF, alpha: 0.2)
        view.layer.cornerRadius = 12/2
        
        return view
    }()
    
    let thirdBallView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex6: 0x0066FF, alpha: 0.2)
        view.layer.cornerRadius = 8/2
        
        return view
    }()
    
    var firstSizeConstraint: Constraint?
    var secondSizeConstraint: Constraint?
    var thirdSizeConstraint: Constraint?
    
    private var completionModel: Any?
    private var needToStopAnimation: Bool = false
    
    override func setup() {
        addSubview(firstBallView)
        addSubview(secondBallView)
        addSubview(thirdBallView)
        
        setupConstraints()
    }
    
    func startAnimation(_ completion: @escaping (Any?) -> Void) {
        firstSizeConstraint?.update(offset: 12)
        secondSizeConstraint?.update(offset: 16)
                
        UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveEaseInOut) {
            self.firstBallView.layer.cornerRadius = 12/2
            self.secondBallView.layer.cornerRadius = 16/2
            
            self.firstBallView.backgroundColor = self.color.withAlphaComponent(0.2)
            self.secondBallView.backgroundColor = self.color
            
            self.layoutIfNeeded()
        } completion: { _ in
            self.firstSizeConstraint?.update(offset: 8)
            self.secondSizeConstraint?.update(offset: 12)
            self.thirdSizeConstraint?.update(offset: 16)
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut) {
                self.firstBallView.layer.cornerRadius = 8/2
                self.secondBallView.layer.cornerRadius = 12/2
                self.thirdBallView.layer.cornerRadius = 16/2
                
                self.firstBallView.backgroundColor = self.color.withAlphaComponent(0.2)
                self.secondBallView.backgroundColor = self.color.withAlphaComponent(0.2)
                self.thirdBallView.backgroundColor = self.color
                
                self.layoutIfNeeded()
            } completion: { _ in
                if self.needToStopAnimation {
                    completion(self.completionModel)
                } else {
                    self.reset {
                        self.startAnimation(completion)
                    }
                }
            }
        }
    }
    
    func reset(_ completion: @escaping () -> Void) {
        firstSizeConstraint?.update(offset: 16)
        secondSizeConstraint?.update(offset: 12)
        thirdSizeConstraint?.update(offset: 8)
        
        UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveEaseInOut) {
            self.firstBallView.layer.cornerRadius = 16/2
            self.secondBallView.layer.cornerRadius = 12/2
            self.thirdBallView.layer.cornerRadius = 8/2
            
            self.firstBallView.backgroundColor = self.color
            self.secondBallView.backgroundColor = self.color.withAlphaComponent(0.2)
            self.thirdBallView.backgroundColor = self.color.withAlphaComponent(0.2)
            
            self.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
    
    func stopAnimation(with model: Any? = nil) {
        completionModel = model
        needToStopAnimation = true
    }

    private func setupConstraints() {
        firstBallView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            firstSizeConstraint = make.size.equalTo(16.0).constraint
        }
        
        secondBallView.snp.makeConstraints { make in
            make.left.equalTo(firstBallView.snp.right).offset(4.0)
            make.bottom.equalToSuperview()
            secondSizeConstraint = make.size.equalTo(12.0).constraint
        }
        
        thirdBallView.snp.makeConstraints { make in
            make.left.equalTo(secondBallView.snp.right).offset(4.0)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            thirdSizeConstraint = make.size.equalTo(8.0).constraint
        }
    }
}
