import UIKit

class SettingsViewController: UIViewController {

    var mainView: SettingsView {
        return view as! SettingsView
    }
    
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}
