import UIKit
import Security

class CheckSeedView: RootView {
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.back(), for: .normal)
        button.tintColor = R.color.textPrimary()
        
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 18, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        label.text = localizable.seedPhraseCheckTitle()
        
        return label
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.register(SeedWordCell.self, forCellReuseIdentifier: SeedWordCell.description())
        view.register(SeedHeaderCell.self, forCellReuseIdentifier: SeedHeaderCell.description())
        view.register(SeedNextButtonCell.self, forCellReuseIdentifier: SeedNextButtonCell.description())
        view.separatorStyle = .none
        view.allowsSelection = false
        view.estimatedRowHeight = UITableView.automaticDimension
        view.rowHeight = UITableView.automaticDimension
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        return view
    }()
    
    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(localizable.seedPhraseButton(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .interFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 10
        button.backgroundColor = .init(hex6: 0x0066FF)
        
        return button
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(continueButton)
                
        setupConstraints()
    }
    
    func setupContent(for type: CheckSeedViewController.ViewType) {
        switch type {
        case .check:
            continueButton.isHidden = false
            titleLabel.text = localizable.seedPhraseCheckTitle()
            
        case .enter:
            continueButton.isHidden = true
            titleLabel.text = localizable.seedPhraseEnterTitle()
        }
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.size.equalTo(24.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(60.0)
        }
    }
}
