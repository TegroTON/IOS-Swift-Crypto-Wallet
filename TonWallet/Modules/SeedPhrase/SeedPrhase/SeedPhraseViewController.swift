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
    
    let phrases = ["ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple", "ripple"]
    var wordsForCheck = [(index: Int, word: String)]()
    var userWordsForCheck = [Int: String]()
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
    }
    
    @objc private func nextButtonTapped() {
        switch type {
        case .read:
            switchToCheckType()
            
        case .enter: break
        case .check:
            checkUserWords()
        }
    }
    
    private func setupTableView() {
        let firstIndex = Int.random(in: 0..<7)
        let secondIndex = Int.random(in: 7..<15)
        let thirdIndex = Int.random(in: 15...23)
        
        wordsForCheck = [
            (index: firstIndex, word: phrases[firstIndex]),
            (index: secondIndex, word: phrases[secondIndex]),
            (index: thirdIndex, word: phrases[thirdIndex])
        ]
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func switchToCheckType() {
        UIView.transition(with: mainView, duration: 0.3, options: .transitionCrossDissolve) {
            self.mainView.titleLabel.text = R.string.localizable.seedPhraseCheckTitle()
            self.mainView.setSubtitle(text: R.string.localizable.seedPhraseCheckSubtitle())
        }
        
        let firstCell = mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SeedWordCell
        firstCell.textField.becomeFirstResponder()
        
        mainView.tableView.alpha = 1
        mainView.mainStackView.alpha = 0
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
        for index in 0...2 {
            let cell = mainView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! SeedWordCell
            cell.textField.resignFirstResponder()
        }
    }
    
    private func checkUserWords() {
        resignAllFirstResponder()
        
        if userWordsForCheck[wordsForCheck[0].index] == wordsForCheck[0].word {
            if userWordsForCheck[wordsForCheck[1].index] == wordsForCheck[1].word {
                if userWordsForCheck[wordsForCheck[2].index] == wordsForCheck[2].word {
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
}

// MARK: - UITableViewDelegate

extension SeedPhraseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeedWordCell.description(), for: indexPath) as! SeedWordCell
        cell.indexLabel.text = (wordsForCheck[indexPath.row].index + 1).description + "."
        cell.textField.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0 + 16.0
    }
}

extension SeedPhraseViewController: SeedWordCellDelegate {
    func seedWord(didReturned rowIndex: Int) {
        if rowIndex < 2 {
            let nextCell = mainView.tableView.cellForRow(at: IndexPath(row: rowIndex + 1, section: 0)) as! SeedWordCell
            
            nextCell.textField.becomeFirstResponder()
        } else {
            let currentCell = mainView.tableView.cellForRow(at: IndexPath(row: rowIndex, section: 0)) as! SeedWordCell
            
            currentCell.textField.resignFirstResponder()
        }
    }
    
    func seedWord(didEndEditing text: String, word index: Int) {
        userWordsForCheck[index] = text
    }
}

