import UIKit

class CreateViewController: UIViewController {
    
    var mainView: CreateView {
        return view as! CreateView
    }
    
    override func loadView() {
        view = CreateView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return traitCollection.userInterfaceStyle == .light ? .darkContent : .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        mainView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        mainView.connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
    }
    
    @objc private func createButtonTapped() {
        navigationController?.pushViewController(LoadSeedViewController(), animated: true)
    }
    
    @objc private func connectButtonTapped() {
        navigationController?.pushViewController(CheckSeedViewController(type: .enter), animated: true)
    }
    
}
