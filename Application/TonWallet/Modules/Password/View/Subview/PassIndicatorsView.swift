import UIKit

class PassIndicatorsView: RootView {
    
    let firstContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = R.color.borderColor()?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 24/2
        
        return view
    }()
    
    let firstView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18/2
        view.backgroundColor = .clear
        
        return view
    }()
    
    let secondContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = R.color.borderColor()?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 24/2
        
        return view
    }()
    
    let secondView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18/2
        view.backgroundColor = .clear
        
        return view
    }()
    
    let thirdContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = R.color.borderColor()?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 24/2
        
        return view
    }()
    
    let thirdView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18/2
        view.backgroundColor = .clear
        
        return view
    }()
    
    let fourthContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = R.color.borderColor()?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 24/2
        
        return view
    }()
    
    let fourthView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18/2
        view.backgroundColor = .clear
        
        return view
    }()
    
    override func setup() {
        backgroundColor = .clear
        
        addSubview(firstContainer)
        addSubview(secondContainer)
        addSubview(thirdContainer)
        addSubview(fourthContainer)
        
        firstContainer.addSubview(firstView)
        secondContainer.addSubview(secondView)
        thirdContainer.addSubview(thirdView)
        fourthContainer.addSubview(fourthView)
        
        setupConstraints()
    }
    
    func animateRedIndicators() {
        UIView.animate(withDuration: 0.3) {
            self.fourthContainer.layer.borderColor = UIColor(hex6: 0xF44242).cgColor
            self.fourthView.backgroundColor = .init(hex6: 0xF44242)
            
            self.thirdContainer.layer.borderColor = UIColor(hex6: 0xF44242).cgColor
            self.thirdView.backgroundColor = .init(hex6: 0xF44242)
            
            self.secondContainer.layer.borderColor = UIColor(hex6: 0xF44242).cgColor
            self.secondView.backgroundColor = .init(hex6: 0xF44242)
            
            self.firstContainer.layer.borderColor = UIColor(hex6: 0xF44242).cgColor
            self.firstView.backgroundColor = .init(hex6: 0xF44242)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.turnOffIndicators()
            }
        }

    }
    
    func turnOffIndicators() {
        firstContainer.layer.borderColor = R.color.borderColor()?.cgColor
        firstView.backgroundColor = .clear
        
        secondContainer.layer.borderColor = R.color.borderColor()?.cgColor
        secondView.backgroundColor = .clear
        
        thirdContainer.layer.borderColor = R.color.borderColor()?.cgColor
        thirdView.backgroundColor = .clear
        
        fourthContainer.layer.borderColor = R.color.borderColor()?.cgColor
        fourthView.backgroundColor = .clear
    }
    
    func changeIndicator(isOn: Bool, index: Int, animate: Bool) {
        changeIndicator(isOn: isOn, index: index)
        
        if animate {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
                switch index {
                case 0: self.firstView.transform = CGAffineTransform(scaleX: 24/18, y: 24/18)
                case 1: self.secondView.transform = CGAffineTransform(scaleX: 24/18, y: 24/18)
                case 2: self.thirdView.transform = CGAffineTransform(scaleX: 24/18, y: 24/18)
                case 3: self.fourthView.transform = CGAffineTransform(scaleX: 24/18, y: 24/18)
                default: break
                }
            } completion: { _ in
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
                    switch index {
                    case 0: self.firstView.transform = .identity
                    case 1: self.secondView.transform = .identity
                    case 2: self.thirdView.transform = .identity
                    case 3: self.fourthView.transform = .identity
                    default: break
                    }
                }
            }

        }
    }
    
    private func changeIndicator(isOn: Bool, index: Int) {
        let borderColor: UIColor? = isOn ? .init(hex6: 0x0066FF) : R.color.borderColor()
        let color: UIColor? = isOn ? .init(hex6: 0x0066FF) : .clear
        
        if index == 3 {
            fourthContainer.layer.borderColor = borderColor?.cgColor
            fourthView.backgroundColor = color
        } else if index == 2 {
            thirdContainer.layer.borderColor = borderColor?.cgColor
            thirdView.backgroundColor = color
        } else if index == 1 {
            secondContainer.layer.borderColor = borderColor?.cgColor
            secondView.backgroundColor = color
        } else if index == 0 {
            firstContainer.layer.borderColor = borderColor?.cgColor
            firstView.backgroundColor = color
        }
    }
    
    private func setupConstraints() {
        firstContainer.snp.makeConstraints { make in
            make.size.equalTo(24.0)
            make.left.top.bottom.equalToSuperview()
        }
        
        secondContainer.snp.makeConstraints { make in
            make.size.equalTo(24.0)
            make.left.equalTo(firstContainer.snp.right).offset(24.0)
            make.centerY.equalToSuperview()
        }
        
        thirdContainer.snp.makeConstraints { make in
            make.size.equalTo(24.0)
            make.left.equalTo(secondContainer.snp.right).offset(24.0)
            make.centerY.equalToSuperview()
        }
        
        fourthContainer.snp.makeConstraints { make in
            make.size.equalTo(24.0)
            make.left.equalTo(thirdContainer.snp.right).offset(24.0)
            make.centerY.right.equalToSuperview()
        }
        
        firstView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(18.0)
        }
        
        secondView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(18.0)
        }
        
        thirdView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(18.0)
        }
        
        fourthView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(18.0)
        }
    }
}
