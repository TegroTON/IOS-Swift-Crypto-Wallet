import UIKit

class MainView: RootView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.mainTitle()
        label.font = .montserratFont(ofSize: 20, weight: .semiBold)
        label.textColor = R.color.textColor()
        label.textAlignment = .center
        
        return label
    }()
    
    override func setup() {
        backgroundColor = R.color.background()
        
        addSubview(titleLabel)
        
        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(18.0)
            make.left.right.equalToSuperview()
        }
    }
}
