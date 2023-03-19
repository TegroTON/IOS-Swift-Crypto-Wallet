import UIKit

class ConfirmCommentView: RootView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.sendConfirmComment()
        label.font = .interFont(ofSize: 16, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let textView: TextView = {
        let view = TextView()
        view.minimumHeight = 80.0
        view.maxHeight = 250.0
        view.placeholder = R.string.localizable.sendConfirmCommentPlaceholder()
        view.backgroundColor = R.color.bgInputs()
        view.layer.borderColor = R.color.borderColor()?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        view.font = .interFont(ofSize: 14, weight: .regular)
        view.textColor = R.color.textPrimary()
        view.placeholderColor = R.color.textSecond()
        
        return view 
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.sendConfirmCommentDescription()
        label.font = .interFont(ofSize: 12, weight: .italic)
        label.textColor = R.color.textSecond()
        label.alpha = 0.8
        
        return label
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(24.0)
        }
        
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24.0)
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32.0)
            make.top.equalTo(textView.snp.bottom).offset(8.0)
            make.bottom.equalToSuperview()
        }
    }

}
