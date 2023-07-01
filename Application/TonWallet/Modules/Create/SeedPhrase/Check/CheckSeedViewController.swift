import UIKit

protocol CheckSeedDelegate: AnyObject {
    func checkSeed(_ controller: CheckSeedViewController, approved wallet: CreatedWallet)
}

class CheckSeedViewController: UIViewController {

    enum ViewType {
        case check(CreatedWallet)
        case create
    }

    weak var delegate: CheckSeedDelegate?
    
    private let type: ViewType
    
    private let checkQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).checkSeed")
    private var wordsForCheck = [(index: Int, word: String)]()
    private var userSeedPhrase = [Int: String]()
    private var didAppeared: Bool = false

    private var mainView: CheckSeedView { view as! CheckSeedView }
    override func loadView() { view = CheckSeedView() }
    
    init(type: ViewType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        
        switch type {
        case .create:
            wordsForCheck = Array(0...23).map { (index: $0, word: "") }
            
        case .check(let createdWallet):
            let mnemonics = createdWallet.mnemonics
            let firstIndex = Int.random(in: 0..<7)
            let secondIndex = Int.random(in: 7..<15)
            let thirdIndex = Int.random(in: 15...23)

            wordsForCheck = [
                (index: firstIndex, word: mnemonics[firstIndex]),
                (index: secondIndex, word: mnemonics[secondIndex]),
                (index: thirdIndex, word: mnemonics[thirdIndex])
            ]
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.addTapGesture(target: self, action: #selector(resignAllFirstResponder))
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
    
    /// action in check state
    @objc private func continueButtonTapped() {
        for index in 0..<wordsForCheck.count {
            let word = wordsForCheck[index]
            if userSeedPhrase[word.index] != word.word {
                return
            }
        }
        
        if case let .check(createdWallet) = type {
            delegate?.checkSeed(self, approved: createdWallet)
        }
    }
    
    /// action in create state
    @objc private func connectButtonTapped(_ sender: UIButton) {
        resignAllFirstResponder()
        let words = Array(0...23).compactMap { userSeedPhrase[$0] }
        
        if words.count == 24 && Mnemonic.mnemonicValidate(mnemonicArray: words) {
            WalletManager.shared.createNewWallet(mnemonics: words) { result in
                switch result {
                case .success(let wallet):
                    self.delegate?.checkSeed(self, approved: wallet)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            // TODO: scroll to and show wrong phrase
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate

extension CheckSeedViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch type {
        case .create: return 3
        case .check: return 2
        }
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
            switch type {
            case .check:
                text = localizable.seedPhraseCheckSubtitle(
                    (wordsForCheck[0].index + 1).description,
                    (wordsForCheck[1].index + 1).description,
                    (wordsForCheck[2].index + 1).description
                )
                cell.imgView.image = R.image.seedPhraseCheck()
                
            case .create:
                text = localizable.seedPhraseEnterSubtitle()
                cell.imgView.image = R.image.seedPhraseEnter()
            }
            
            cell.setSubtitle(text: text)
            
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
        
        switch type {
        case .check:
            let word = wordsForCheck[rowIndex]
            return userSeedPhrase[word.index] == word.word
            
        case .create:
            return true
        }
    }
}
