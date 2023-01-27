import UIKit
import Atributika

class SeedPhraseView: UIView {

    let textField = UITextField()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.seedPhrase()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .montserratFont(ofSize: 18, weight: .medium)
        label.textColor = R.color.textColor()
        label.textAlignment = .center
        
        return label
    }()
    
    let subtitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.29
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.montserratFont(ofSize: 14, weight: .medium))
            .foregroundColor(R.color.subtitleColor()!)
        
        label.attributedText = R.string.localizable.seedPhraseReadSubtitle().styleAll(style)
        
        return label
    }()
    
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
        button.titleLabel?.font = .montserratFont(ofSize: 14, weight: .semiBold)
        button.layer.cornerRadius = 6
        button.backgroundColor = .init(hex6: 0x4285F4)
        
        return button
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.register(SeedWordCell.self, forCellReuseIdentifier: SeedWordCell.description())
        view.register(SeedNextButtonCell.self, forCellReuseIdentifier: SeedNextButtonCell.description())
        view.alpha = 0
        view.separatorStyle = .none
        view.allowsSelection = false
        view.estimatedRowHeight = UITableView.automaticDimension
        view.rowHeight = UITableView.automaticDimension
        
        return view
    }()
    
    lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        view.axis = .horizontal
        view.spacing = 70
        view.distribution = .fillEqually
        view.alignment = .center
        
        return view
    }()
    
    init(view type: SeedPhraseViewController.ViewType) {
        super.init(frame: .zero)
        backgroundColor = R.color.background()
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(mainStackView)
        addSubview(nextButton)
        addSubview(tableView)
        
        setupContent(for: type)
        setupConstraints(for: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(for type: SeedPhraseViewController.ViewType) {
        switch type {
        case .enter: enterConstraints()
        case .read: readContsraints()
        case .check: checkConstraints()
        }
    }
    
    func setupContent(for type: SeedPhraseViewController.ViewType) {
        switch type {
        case .read:
            titleLabel.text = R.string.localizable.seedPhraseReadTitle()
            setSubtitle(text: R.string.localizable.seedPhraseReadSubtitle())
            
        case .check:
            titleLabel.text = R.string.localizable.seedPhraseCheckTitle()
            setSubtitle(text: R.string.localizable.seedPhraseCheckSubtitle())
            
        case .enter:
            titleLabel.text = R.string.localizable.seedPhraseEnterTitle()
            setSubtitle(text: R.string.localizable.seedPhraseEnterSubtitle())
            
            mainStackView.isHidden = true
            tableView.alpha = 1
        }
    }
    
    func setSubtitle(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.29
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.montserratFont(ofSize: 14, weight: .medium))
            .foregroundColor(R.color.subtitleColor()!)
        
        subtitleLabel.attributedText = text.styleAll(style)
    }
    
    private func enterConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(35.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(80.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40.0)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(30.0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
        
    private func readContsraints() {
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        mainStackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(35.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(80.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40.0)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(30.0)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24.0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-38.0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8.0)
            make.left.right.equalToSuperview().inset(78.0)
            make.height.equalTo(48.0)
        }
    }
    
    /// using after read constraints
    private func checkConstraints() {
        
    }
}
