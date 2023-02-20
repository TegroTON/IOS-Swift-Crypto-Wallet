import UIKit

class LoadSeedViewController: UIViewController {

    var mainView: LoadSeedView {
        return view as! LoadSeedView
    }
    
    override func loadView() {
        view = LoadSeedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}
