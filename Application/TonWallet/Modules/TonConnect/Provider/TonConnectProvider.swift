import UIKit
import Alamofire

protocol TonConnectProviderDelegate: AnyObject {
    func tonConnect(_ provider: TonConnectProvider, manifest: DAppManifest)
    func tonConnect(_ provider: TonConnectProvider, failureManifest error: TonConnectError)
}

enum TonConnectError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

class TonConnectProvider {
    
    weak var delegate: TonConnectProviderDelegate?
    
    func requestManifest(with url: String) {
        guard let url = URL(string: url) else {
            delegate?.tonConnect(self, failureManifest: .invalidURL)
            return
        }
        
        AF.request(url).response { [weak self] responseData in
            guard let self = self else { return }
            
            do {
                if let test = try responseData.result.get() {
                    let manifest = try JSONDecoder().decode(DAppManifest.self, from: test)
                    delegate?.tonConnect(self, manifest: manifest)
                } else {
                    delegate?.tonConnect(self, failureManifest: .invalidData)
                }
            } catch {
                print(error)
                self.delegate?.tonConnect(self, failureManifest: .invalidResponse)
            }
        }
    }
}
