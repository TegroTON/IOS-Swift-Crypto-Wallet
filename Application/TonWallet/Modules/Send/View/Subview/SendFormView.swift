import UIKit
import SwiftUI

class SendFormView: RootView {
    
    let balanceContainer: UIView = UIView()
    let scanContainer: UIView = UIView()
    let pasteContainer: UIView = UIView()
    let tokenView: SendTokenView = SendTokenView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.sendFormTitle()
        label.font = .interFont(ofSize: 16, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let addressTextField: TextField = {
        let view = TextField()
        view.backgroundColor = R.color.bgInputs()
        view.layer.borderColor = R.color.borderColor()?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.contentInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 20.0, right: 72.0)
        view.smartQuotesType = .no
        view.smartDashesType = .no
        view.autocorrectionType = .no
        view.smartInsertDeleteType = .no 
        view.spellCheckingType = .no
        view.autocapitalizationType = .none
        view.keyboardType = .default
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.textSecond()!,
            .font: UIFont.interFont(ofSize: 14, weight: .regular)
        ]

        view.attributedPlaceholder = NSMutableAttributedString(
            string: R.string.localizable.sendFormAddress(),
            attributes: attributes
        )
        
        return view
    }()
    
    let amountTextField: TextField = {
        let view = TextField()
        view.backgroundColor = R.color.bgInputs()
        view.layer.borderColor = R.color.borderColor()?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.contentInset = UIEdgeInsets(top: 17.0, left: 16.0, bottom: 17.0, right: 222.0)
        view.font = .interFont(ofSize: 20, weight: .semiBold)
        view.textColor = R.color.textPrimary()
        view.keyboardType = .decimalPad
        view.smartQuotesType = .no
        view.smartDashesType = .no
        view.autocorrectionType = .no
        view.smartInsertDeleteType = .no
        view.spellCheckingType = .no
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.textSecond()!,
            .font: UIFont.interFont(ofSize: 20, weight: .semiBold)
        ]

        view.attributedPlaceholder = NSMutableAttributedString(
            string: 0.description,
            attributes: attributes
        )
        
        return view
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.sendFormBalance()
        label.font = .interFont(ofSize: 14, weight: .medium)
        label.textColor = R.color.textSecond()
        
        return label
    }()
    
    let balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.sendFormBalanceAmount("697", "TON")
        label.font = .interFont(ofSize: 14, weight: .medium)
        label.textColor = .init(hex6: 0x0066FF)
        
        return label
    }()
    
    let fiatLabel: UILabel = {
        let label = UILabel()
        label.text = "~ 0 USD"
        label.font = .interFont(ofSize: 14, weight: .medium)
        label.textColor = R.color.textSecond()
        
        return label
    }()
    
    let scanImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.scanBarcode()
        view.tintColor = R.color.textSecond()
        
        return view
    }()
    
    let pasteImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.paste()
        view.tintColor = R.color.textSecond()
        
        return view
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(addressTextField)
        addSubview(amountTextField)
        addSubview(balanceContainer)
        
        balanceContainer.addSubview(balanceLabel)
        balanceContainer.addSubview(balanceAmountLabel)
        
        amountTextField.addSubview(tokenView)
        amountTextField.addSubview(fiatLabel)
        
        addressTextField.addSubview(scanContainer)
        addressTextField.addSubview(pasteContainer)
        
        scanContainer.addSubview(scanImageView)
        pasteContainer.addSubview(pasteImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.top.equalToSuperview()
        }
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        pasteContainer.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8.0)
            make.bottom.equalToSuperview().offset(-8.0)
        }
        
        pasteImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8.0)
            make.size.equalTo(20.0)
        }
        
        scanContainer.snp.makeConstraints { make in
            make.right.equalTo(pasteContainer.snp.left)
            make.bottom.equalToSuperview().offset(-8.0)
        }
        
        scanImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8.0)
            make.size.equalTo(20.0)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        tokenView.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(8.0)
        }
        
        fiatLabel.snp.makeConstraints { make in
            make.right.equalTo(tokenView.snp.left).offset(-20.0)
            make.centerY.equalToSuperview()
        }
            
        balanceContainer.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(8.0)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        balanceAmountLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-8.0)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.right.equalTo(balanceAmountLabel.snp.left).offset(-13.0)
            make.left.equalToSuperview().offset(24.0)
            make.centerY.equalTo(balanceAmountLabel.snp.centerY)
        }
    }

}
