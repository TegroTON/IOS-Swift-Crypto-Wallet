import UIKit

class ReceiveViewController: UIViewController {
    
    let wallet: Wallet
    let colorFilter = CIFilter(name: "CIFalseColor")
    let qrQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).qrQueue")
    
    var mainView: ReceiveView {
        return view as! ReceiveView
    }
    
    init(wallet: Wallet) {
        self.wallet = wallet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ReceiveView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        
        mainView.headerView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            mainView.updateLayers()
            
            qrQueue.async {
                self.updateColorFilterForTheme()
                if let outputImage = self.colorFilter?.outputImage {
                    let image = UIImage(ciImage: outputImage)
                    
                    DispatchQueue.main.async {
                        self.mainView.set(qr: image)
                    }
                }
            }
        }
    }
    
    // MARK: - Private actions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Private methods
    
    //TODO: нужно придумать мб что то по типо Constraint.transferURL(for wallet:_)
    private func setupContent() {
        let address = wallet.selectedAddress?.address ?? ""
        mainView.set(address: address)
        
        let urlString = "ton://transfer/\(address)"
        generateQRCode(from: urlString) { image in
            self.mainView.set(qr: image)
        }
    }
    
    private func generateQRCode(from string: String, completion: @escaping (UIImage?) -> Void) {
        qrQueue.async {
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                let data = string.data(using: .utf8)
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                filter.setValue(data, forKey: "inputMessage")
                
                if let output = filter.outputImage?.transformed(by: transform) {
                    self.colorFilter?.setValue(output, forKey: "inputImage")
                    self.updateColorFilterForTheme()
                    
                    if let outputImage = self.colorFilter?.outputImage {
                        let image = UIImage(ciImage: outputImage)
                        
                        DispatchQueue.main.async {
                            completion(image)
                        }
                        
                        return
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    private func updateColorFilterForTheme() {
        let currentTheme = UITraitCollection.current.userInterfaceStyle
        colorFilter?.setDefaults()
        
        if currentTheme == .dark {
            colorFilter?.setValue(CIColor(color: .white), forKey: "inputColor0")
            colorFilter?.setValue(CIColor(color: R.color.bgPrimary()!), forKey: "inputColor1")
        } else {
            colorFilter?.setValue(CIColor(color: .black), forKey: "inputColor0")
            colorFilter?.setValue(CIColor(color: .white), forKey: "inputColor1")
        }
    }
}
