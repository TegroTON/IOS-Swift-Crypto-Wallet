import UIKit

protocol SeedWordCellDelegate: AnyObject {
    func seedWord(didEndEditing text: String, word index: Int)
    func seedWord(didReturned rowIndex: Int)
}

class SeedWordCell: UITableViewCell {

    weak var delegate: SeedWordCellDelegate?
    
    let containerView = UIView()
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .montserratFont(ofSize: 14, weight: .medium)
        label.textColor = R.color.subtitleColor()
        label.textAlignment = .left
        
        return label
    }()
    
    let textField: UITextField = {
        let view = UITextField()
        view.font = .montserratFont(ofSize: 16, weight: .medium)
        view.textColor = R.color.textColor()
        view.autocorrectionType = .no
        view.keyboardType = .default
        view.autocapitalizationType = .none
        
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex6: 0xF3F3F3)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(indexLabel)
        containerView.addSubview(textField)
        containerView.addSubview(separatorView)
        
        textField.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(gesture)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cellTapped() {
        textField.becomeFirstResponder()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16.0)
        }
        
        indexLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(36.0)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(64.0)
            make.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
    }
}

// MARK: - UITextFieldDelegate

extension SeedWordCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        separatorView.backgroundColor = .init(hex6: 0xF3F3F3)
        delegate?.seedWord(didReturned: textField.tag)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {        
        UIView.animate(withDuration: 0.3) {
            self.separatorView.backgroundColor = .init(hex6: 0x4285F4)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end", textField.tag)
        separatorView.backgroundColor = .init(hex6: 0xF3F3F3)
        
        var indexText = indexLabel.text!
        indexText.removeLast()
        
        let wordIndex = Int(indexText)! - 1
        delegate?.seedWord(didEndEditing: textField.text!, word: wordIndex)
    }
}
