import UIKit
import Atributika

class SeedHeaderCell: UITableViewCell {
    
    let imgView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.seedPhraseCheck()
        
        return view
    }()
    
    let subtitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        contentView.addSubview(imgView)
        contentView.addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubtitle(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.interFont(ofSize: 16, weight: .regular))
            .foregroundColor(R.color.textSecond()!)
        
        subtitleLabel.attributedText = text.styleAll(style)
    }
    
    private func setupConstraints() {
        imgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(80.0)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24.0)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.top.equalTo(imgView.snp.bottom).offset(32.0)
            make.bottom.equalToSuperview().offset(-12.0)
        }
    }
}
