import UIKit

class SeedWordView: UIView {

    let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 16, weight: .regular)
        label.textColor = R.color.textSecond()
        label.textAlignment = .left
        
        return label
    }()
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.font = .montserratFont(ofSize: 16, weight: .regular)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .left
        
        return label
    }()
    
    init(index: Int, word: String) {
        super.init(frame: .zero)
        
        indexLabel.text = index.description + "."
        wordLabel.text = word
        
        addSubview(indexLabel)
        addSubview(wordLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupConstraints() {
        indexLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(24.0)
        }
        
        wordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30.0)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}
