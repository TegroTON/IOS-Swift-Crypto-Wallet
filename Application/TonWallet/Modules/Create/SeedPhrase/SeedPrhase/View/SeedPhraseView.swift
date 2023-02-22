import UIKit
import Atributika

class SeedPhraseView: RootView {
    
    let headerView: SeedPhraseHeaderView = SeedPhraseHeaderView()
    let warningView: SeedPhraseWarningView = SeedPhraseWarningView()
    
    let leftStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.distribution = .fill
        view.alignment = .leading
        
        return view
    }()
    
    let rightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.distribution = .fill
        view.alignment = .leading
        
        return view
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(R.string.localizable.seedPhraseButton(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .interFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 10
        button.backgroundColor = .init(hex6: 0x0066FF)
        
        return button
    }()
    
    lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        view.axis = .horizontal
        view.spacing = 70
        view.distribution = .fillEqually
        view.alignment = .center
        
        return view
    }()
        
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(headerView)
        addSubview(warningView)
        addSubview(mainStackView)
        addSubview(nextButton)
                
        setupConstraints()
    }
            
    private func setupConstraints() {
        warningView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        mainStackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
                
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        warningView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(warningView.snp.bottom).offset(24.0)
            make.centerX.equalToSuperview()
        }
                
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(60.0)
        }
    }
}
