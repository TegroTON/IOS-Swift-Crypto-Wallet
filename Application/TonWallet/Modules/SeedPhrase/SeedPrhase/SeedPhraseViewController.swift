import UIKit

class SeedPhraseViewController: UIViewController {

    enum ViewType {
        case enter
        case read
        case check
    }
    
    var mainView: SeedPhraseView {
        return view as! SeedPhraseView
    }
    
    let phrases = TonManager.shared.mnemonics ?? []
    var wordsForCheck = [(index: Int, word: String)]()
    var userSeedPhrase = [Int: String]()
    
    var type: ViewType {
        didSet {
            mainView.setupConstraints(for: type)
            UIView.animate(withDuration: 0.3) {
                self.mainView.layoutSubviews()
            }
        }
    }
    
    init(type: ViewType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        
        if type == .enter {
            wordsForCheck = Array(0...23).map { (index: $0, word: "") }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SeedPhraseView(view: type)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(resignAllFirstResponder))
        mainView.addGestureRecognizer(gesture)
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        configureSeedStack()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if type == .enter {
            let cell = mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SeedWordCell
            cell.textField.becomeFirstResponder()
        }
    }
    
    @objc private func nextButtonTapped() {
        switch type {
        case .read:
            switchToCheckType()
            
        case .enter:
            connectWallet()
            
        case .check:
            checkUserWords()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let height = frame.cgRectValue.height
        
        mainView.tableView.snp.remakeConstraints { make in
            make.top.equalTo(mainView.subtitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-height)
        }
    }
    
    @objc private func keyboardWillHide() {
        mainView.tableView.snp.remakeConstraints { make in
            make.top.equalTo(mainView.subtitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        if type != .enter {
            let firstIndex = Int.random(in: 0..<7)
            let secondIndex = Int.random(in: 7..<15)
            let thirdIndex = Int.random(in: 15...23)
            
            wordsForCheck = [
                (index: firstIndex, word: phrases[firstIndex]),
                (index: secondIndex, word: phrases[secondIndex]),
                (index: thirdIndex, word: phrases[thirdIndex])
            ]
        }
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func switchToCheckType() {
        UIView.transition(with: mainView, duration: 0.3, options: .transitionCrossDissolve) {
            self.mainView.setupContent(for: .check)
        }
        
        let firstCell = mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SeedWordCell
        firstCell.textField.becomeFirstResponder()
        
        mainView.tableView.alpha = 1
        mainView.mainStackView.alpha = 0
        mainView.nextButton.alpha = 0
        type = .check
    }
    
    private func configureSeedStack() {
        for (index, word) in phrases.enumerated() {
            let view = SeedWordView(index: index + 1, word: word)
            
            if index < 12 {
                mainView.leftStackView.addArrangedSubview(view)
            } else {
                mainView.rightStackView.addArrangedSubview(view)
            }
        }        
    }
    
    @objc private func resignAllFirstResponder() {
        mainView.endEditing(true)
    }
    
    private func checkUserWords() {
        resignAllFirstResponder()
        
        if userSeedPhrase[wordsForCheck[0].index] == wordsForCheck[0].word {
            if userSeedPhrase[wordsForCheck[1].index] == wordsForCheck[1].word {
                if userSeedPhrase[wordsForCheck[2].index] == wordsForCheck[2].word {
                    navigationController?.pushViewController(PasswordViewController(), animated: true)
                } else {
                    print("not correct 3rd word")
                }
            } else {
                print("not correct 2nd word")
            }
        } else {
            print("not correct 1st word")
        }
    }
    
    private func connectWallet() {
        resignAllFirstResponder()
        let words = Array(0...23).compactMap { userSeedPhrase[$0] }
        
        if words.count == 24 {
            TonManager.shared.delegate = self
            TonManager.shared.calculateKeyPair(mnemonics: words)
        } else {
            let index = IndexPath(row: words.count - 1, section: 0)
            mainView.tableView.scrollToRow(at: index, at: .middle, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate

extension SeedPhraseViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return wordsForCheck.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SeedWordCell.description(), for: indexPath) as! SeedWordCell
            cell.indexLabel.text = (wordsForCheck[indexPath.row].index + 1).description + "."
            cell.textField.text = userSeedPhrase[indexPath.row]
            cell.textField.tag = indexPath.row
            cell.delegate = self
            
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SeedNextButtonCell.description(), for: indexPath) as! SeedNextButtonCell
            cell.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - SeedWordCellDelegate

extension SeedPhraseViewController: SeedWordCellDelegate {
    func seedWord(didReturned rowIndex: Int) {
        if rowIndex < wordsForCheck.count - 1 {
            let index = IndexPath(row: rowIndex + 1, section: 0)
            let nextCell = mainView.tableView.cellForRow(at: index) as! SeedWordCell
            
            nextCell.textField.becomeFirstResponder()
            mainView.tableView.scrollToRow(at: index, at: .middle, animated: true)
        } else {
            let currentCell = mainView.tableView.cellForRow(at: IndexPath(row: rowIndex, section: 0)) as! SeedWordCell
            
            currentCell.textField.resignFirstResponder()
        }
    }
    
    func seedWord(didEndEditing text: String, word index: Int) {
        userSeedPhrase[index] = text
    }
}

// MARK: - TonManagerDelegate

extension SeedPhraseViewController: TonManagerDelegate {
    func ton(keyPairCalculated result: Result<TonKeyPair, Error>) {
        switch result {
        case .success(let keyPair):
            print("key pair", keyPair)
            
        case .failure(let error):
            print("❤️ error calculate key pair connect wallet", error)
        }
    }
}
