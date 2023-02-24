import UIKit

class TabBarView: RootView {

    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.borderColor()
        
        return view
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(separatorView)
        
        setupConstraints()
    }

    private func setupConstraints() {
        separatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }
}
