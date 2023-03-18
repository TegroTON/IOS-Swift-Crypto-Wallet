import UIKit
import Atributika

class CheckSeedViewController: UIViewController {
    
    enum ViewType {
        case check
        case enter
    }
    
    var mainView: CheckSeedView {
        return view as! CheckSeedView
    }
    
    let type: ViewType
    let phrases = TonManager.shared.mnemonics ?? []
    var wordsForCheck = [(index: Int, word: String)]()
    var userSeedPhrase = [Int: String]()
    var didAppeared: Bool = false
    
    override func loadView() {
        view = CheckSeedView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(resignAllFirstResponder))
        mainView.addGestureRecognizer(gesture)
        
        mainView.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        setupTableView()
        mainView.setupContent(for: type)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didAppeared {
            didAppeared = true
            let cell = mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SeedWordCell
            cell.textField.becomeFirstResponder()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let height = frame.cgRectValue.height
        mainView.tableView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: height, right: 0.0)
    }
    
    @objc private func keyboardWillHide() {
    }
    
    @objc private func resignAllFirstResponder() {
        mainView.endEditing(true)
    }
    
    @objc private func continueButtonTapped() {
        for index in 0..<wordsForCheck.count {
            let word = wordsForCheck[index]
            if userSeedPhrase[word.index] != word.word {
                return
            }
        }
        
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }
    
    @objc private func connectButtonTapped() {
        resignAllFirstResponder()
        let words = Array(0...23).compactMap { userSeedPhrase[$0] }
        
        if words.count == 24 {
            TonManager.shared.delegate = self
            TonManager.shared.mnemonics = words
            TonManager.shared.calculateKeyPair(mnemonics: words)
        } else {
            // TODO: scroll to and show wrong phrase
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        if type == .check {
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
    
}

// MARK: - UITableViewDelegate

extension CheckSeedViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {        
        return type == .enter ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return wordsForCheck.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SeedHeaderCell.description(), for: indexPath) as! SeedHeaderCell
            
            let text: String
            if type == .check {
                text = R.string.localizable.seedPhraseCheckSubtitle(
                    (wordsForCheck[0].index + 1).description,
                    (wordsForCheck[1].index + 1).description,
                    (wordsForCheck[2].index + 1).description
                )
            } else {
                text = R.string.localizable.seedPhraseEnterSubtitle()
            }
            
            cell.setSubtitle(text: text)
            cell.imgView.image = type == .check ? R.image.seedPhraseCheck() : R.image.seedPhraseEnter()
            
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SeedWordCell.description(), for: indexPath) as! SeedWordCell
            cell.indexLabel.text = (wordsForCheck[indexPath.row].index + 1).description + "."
            cell.textField.text = userSeedPhrase[indexPath.row]
            cell.textField.tag = indexPath.row
            cell.delegate = self
            
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SeedNextButtonCell.description(), for: indexPath) as! SeedNextButtonCell
            cell.nextButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - SeedWordCellDelegate

extension CheckSeedViewController: SeedWordCellDelegate {
    func seedWord(didReturned rowIndex: Int) {
        if rowIndex < wordsForCheck.count - 1 {
            let index = IndexPath(row: rowIndex + 1, section: 1)
            let nextCell = mainView.tableView.cellForRow(at: index) as! SeedWordCell

            nextCell.textField.becomeFirstResponder()
            mainView.tableView.scrollToRow(at: index, at: .middle, animated: true)
        } else {
            let currentCell = mainView.tableView.cellForRow(at: IndexPath(row: rowIndex, section: 1)) as! SeedWordCell

            currentCell.textField.resignFirstResponder()
        }
    }
    
    func seedWord(didEndEditing text: String, word index: Int, rowIndex: Int) -> Bool {
        guard !text.isEmpty else { return true }
        
        userSeedPhrase[index] = text
        
        let word = wordsForCheck[rowIndex]
        return type == .check ? userSeedPhrase[word.index] == word.word : true
    }
}

// MARK: - TonManagerDelegate

extension CheckSeedViewController: TonManagerDelegate {
    func ton(keyPairCalculated result: Result<TonKeyPair, Error>) {
        switch result {
        case .success(let keyPair):
            guard let mnemonics = TonManager.shared.mnemonics else { return }
            let createdWallet = WalletManager.shared.create(wallet: mnemonics)
            WalletManager.shared.set(keys: keyPair, for: createdWallet.id)
            
            navigationController?.pushViewController(PasswordViewController(), animated: true)
            
        case .failure(let error):
            print("❤️ keyPairCalculated error", error)
        }
    }
}
