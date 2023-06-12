import UIKit

protocol SeedWordCellDelegate: AnyObject {
    func seedWord(didEndEditing text: String, word index: Int, rowIndex: Int) -> Bool
    func seedWord(didReturned rowIndex: Int)
}

class SeedWordCell: UITableViewCell {

    weak var delegate: SeedWordCellDelegate?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.bgInputs()
        view.layer.cornerRadius = 10
        view.layer.borderColor = R.color.borderColor()?.cgColor
        
        return view
    }()
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .montserratFont(ofSize: 14, weight: .medium)
        label.textColor = R.color.textSecond()
        label.textAlignment = .left
        
        return label
    }()
    
    let textField: UITextField = {
        let view = UITextField()
        view.font = .montserratFont(ofSize: 16, weight: .medium)
        view.textColor = R.color.textPrimary()
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.returnKeyType = .go
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(indexLabel)
        containerView.addSubview(textField)
        
        textField.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(gesture)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textField.text = nil
        indexLabel.text = nil
    }
    
    @objc private func cellTapped() {
        textField.becomeFirstResponder()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(24.0)
            make.top.equalToSuperview().offset(16.0)
            make.height.equalTo(50.0)
        }
        
        indexLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(52.0)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - UITextFieldDelegate

extension SeedWordCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        containerView.layer.borderWidth = 0
        delegate?.seedWord(didReturned: textField.tag)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {        
        UIView.animate(withDuration: 0.3) {
            self.containerView.layer.borderWidth = 1
            self.containerView.backgroundColor = R.color.bgInputs()
            self.containerView.layer.borderColor = R.color.borderColor()?.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        containerView.layer.borderWidth = 0
        
        var indexText = indexLabel.text!
        indexText.removeLast()
        
        let wordIndex = Int(indexText)! - 1
        guard let isCorrect = delegate?.seedWord(didEndEditing: textField.text!, word: wordIndex, rowIndex: textField.tag) else { return }
        
        if !isCorrect {
            UIView.animate(withDuration: 0.3) {
                self.containerView.layer.borderWidth = 1
                self.containerView.layer.borderColor = UIColor(hex6: 0xEB5757).cgColor
                self.containerView.backgroundColor = .init(hex6: 0xF44242, alpha: 0.08)
            }
        }
    }
}
