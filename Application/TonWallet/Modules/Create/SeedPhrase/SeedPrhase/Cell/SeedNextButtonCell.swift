import UIKit

class SeedNextButtonCell: UITableViewCell {

    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(R.string.localizable.seedPhraseButton(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .montserratFont(ofSize: 14, weight: .semiBold)
        button.layer.cornerRadius = 6
        button.backgroundColor = .init(hex6: 0x4285F4)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        contentView.addSubview(nextButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        nextButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32.0)
            make.left.right.equalToSuperview().inset(78.0)
            make.height.equalTo(48.0)
            make.bottom.equalToSuperview().offset(-8.0)
        }
    }
}
