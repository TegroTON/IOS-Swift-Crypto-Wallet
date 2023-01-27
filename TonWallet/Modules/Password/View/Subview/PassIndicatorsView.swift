import UIKit

class PassIndicatorsView: RootView {
    
    let firstView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24/2
        view.layer.borderWidth = 1
        view.layer.borderColor = R.color.passwordIndicatorBorder()?.cgColor
        view.backgroundColor = R.color.passwordIndicator()
        
        return view
    }()
    
    let secondView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24/2
        view.layer.borderWidth = 1
        view.layer.borderColor = R.color.passwordIndicatorBorder()?.cgColor
        view.backgroundColor = R.color.passwordIndicator()
        
        return view
    }()
    
    let thirdView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24/2
        view.layer.borderWidth = 1
        view.layer.borderColor = R.color.passwordIndicatorBorder()?.cgColor
        view.backgroundColor = R.color.passwordIndicator()
        
        return view
    }()
    
    let fourthView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24/2
        view.layer.borderWidth = 1
        view.layer.borderColor = R.color.passwordIndicatorBorder()?.cgColor
        view.backgroundColor = R.color.passwordIndicator()
        
        return view
    }()
    
    override func setup() {
        backgroundColor = .clear
        
        addSubview(firstView)
        addSubview(secondView)
        addSubview(thirdView)
        addSubview(fourthView)
        
        setupConstraints()
    }
    
    func animateRedIndicators() {
        UIView.animate(withDuration: 0.3) {
            self.fourthView.backgroundColor = .init(hex6: 0xF44242)
            self.fourthView.layer.borderWidth = 0
            
            self.thirdView.backgroundColor = .init(hex6: 0xF44242)
            self.thirdView.layer.borderWidth = 0
            
            self.secondView.backgroundColor = .init(hex6: 0xF44242)
            self.secondView.layer.borderWidth = 0
            
            self.firstView.backgroundColor = .init(hex6: 0xF44242)
            self.firstView.layer.borderWidth = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.fourthView.backgroundColor = R.color.passwordIndicator()
                self.fourthView.layer.borderWidth = 1
                
                self.thirdView.backgroundColor = R.color.passwordIndicator()
                self.thirdView.layer.borderWidth = 1
                
                self.secondView.backgroundColor = R.color.passwordIndicator()
                self.secondView.layer.borderWidth = 1
                
                self.firstView.backgroundColor = R.color.passwordIndicator()
                self.firstView.layer.borderWidth = 1
            }
        }

    }
    
    func turnOffIndicators() {
        fourthView.backgroundColor = R.color.passwordIndicator()
        fourthView.layer.borderWidth = 1
        
        thirdView.backgroundColor = R.color.passwordIndicator()
        thirdView.layer.borderWidth = 1
        
        secondView.backgroundColor = R.color.passwordIndicator()
        secondView.layer.borderWidth = 1
        
        firstView.backgroundColor = R.color.passwordIndicator()
        firstView.layer.borderWidth = 1
    }
    
    func changeIndicator(isOn: Bool, index: Int) {
        let color: UIColor? = isOn ? .init(hex6: 0x4285F4) : R.color.passwordIndicator()
        let width: CGFloat = isOn ? 0 : 1
        
        if index == 3 {
            fourthView.backgroundColor = color
            fourthView.layer.borderWidth = width
        } else if index == 2 {
            thirdView.backgroundColor = color
            thirdView.layer.borderWidth = width
        } else if index == 1 {
            secondView.backgroundColor = color
            secondView.layer.borderWidth = width
        } else if index == 0 {
            firstView.backgroundColor = color
            firstView.layer.borderWidth = width
        }
    }
    
    private func setupConstraints() {
        firstView.snp.makeConstraints { make in
            make.size.equalTo(24.0)
            make.left.top.bottom.equalToSuperview()
        }
        
        secondView.snp.makeConstraints { make in
            make.size.equalTo(24.0)
            make.left.equalTo(firstView.snp.right).offset(20.0)
            make.centerY.equalToSuperview()
        }
        
        thirdView.snp.makeConstraints { make in
            make.size.equalTo(24.0)
            make.left.equalTo(secondView.snp.right).offset(20.0)
            make.centerY.equalToSuperview()
        }
        
        fourthView.snp.makeConstraints { make in
            make.size.equalTo(24.0)
            make.left.equalTo(thirdView.snp.right).offset(20.0)
            make.centerY.right.equalToSuperview()
        }
    }
}
