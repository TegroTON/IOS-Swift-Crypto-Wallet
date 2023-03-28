import UIKit

class PassIndicatorsView: RootView {
    
    enum IndicatorType {
        case on
        case off
        case error
        case blocked
    }
    
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
    
    // MARK: - Public methods
    
    func setAllIndicators(to type: IndicatorType) {
        setIndicator(type: type, index: 0)
        setIndicator(type: type, index: 1)
        setIndicator(type: type, index: 2)
        setIndicator(type: type, index: 3)
    }
    
    func setOn(_ isOn: Bool, indicator index: Int, animate: Bool) {
        let type: IndicatorType = isOn ? .on : .off
        setIndicator(type: type, index: index)
        
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
    
    // MARK: - Private methods
    
    private func setIndicator(type: IndicatorType, index: Int) {
        let borderColor: CGColor?
        let backgroundColor: UIColor?
        
        switch type {
        case .on:
            borderColor = UIColor.init(hex6: 0x0066FF).cgColor
            backgroundColor = .init(hex6: 0x0066FF)
            
        case .off:
            borderColor = R.color.borderColor()?.cgColor
            backgroundColor = UIColor.clear
            
        case .error:
            borderColor = UIColor(hex6: 0xF44242).cgColor
            backgroundColor = UIColor(hex6: 0xF44242)
            
        case .blocked:
            borderColor = R.color.bgThird()?.cgColor
            backgroundColor = R.color.bgThird()
        }
        
        if index == 3 {
            fourthContainer.layer.borderColor = borderColor
            fourthView.backgroundColor = backgroundColor
        } else if index == 2 {
            thirdContainer.layer.borderColor = borderColor
            thirdView.backgroundColor = backgroundColor
        } else if index == 1 {
            secondContainer.layer.borderColor = borderColor
            secondView.backgroundColor = backgroundColor
        } else if index == 0 {
            firstContainer.layer.borderColor = borderColor
            firstView.backgroundColor = backgroundColor
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
