import UIKit

class SeedWordView: UIView {

    let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .montserratFont(ofSize: 14, weight: .medium)
//        label.textColor = R.color.subtitleColor()
        label.textAlignment = .left
        
        return label
    }()
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.font = .montserratFont(ofSize: 14, weight: .medium)
//        label.textColor = R.color.textColor()
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
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}
