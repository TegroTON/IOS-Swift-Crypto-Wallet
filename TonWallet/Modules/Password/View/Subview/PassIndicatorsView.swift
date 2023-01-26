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
