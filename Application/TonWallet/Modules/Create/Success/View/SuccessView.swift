import UIKit

class SuccessView: UIView {

    let containerView: UIView = UIView()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.seedPhraseCreated()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.successCreateTitle()
        label.font = .interFont(ofSize: 24, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.successCreateSubtitle()
        label.font = .interFont(ofSize: 16, weight: .regular)
        label.textColor = R.color.textSecond()
        label.textAlignment = .center
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        alpha = 0
        backgroundColor = R.color.bgPrimary()
        addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didAppear() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.alpha = 1
        }
    }
    
    func willDisappear() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.alpha = 0
        }
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(80.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40.0)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-38.0)
        }
    }
}
