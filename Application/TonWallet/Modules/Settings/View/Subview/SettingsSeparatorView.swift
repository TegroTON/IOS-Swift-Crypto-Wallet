import UIKit

class SettingsSeparatorView: RootView {

    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.borderColor()
        
        return view
    }()
    
    override func setup() {  
        addSubview(separatorView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        separatorView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16.0)
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(1.0)
        }
    }

}
