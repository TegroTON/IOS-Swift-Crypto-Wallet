import UIKit

class CreateViewController: UIViewController {

    var mainView: CreateView {
        return view as! CreateView
    }
    
    override func loadView() {
        view = CreateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            colorAppearanceToggled()
        }
    }
    
    private func colorAppearanceToggled() {
        mainView.updateColors()
    }
    
}
