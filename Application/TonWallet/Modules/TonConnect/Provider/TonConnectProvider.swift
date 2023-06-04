import UIKit
import Alamofire

protocol TonConnectProviderDelegate: AnyObject {
    func tonConnect(_ provider: TonConnectProvider, manifest: DAppManifest)
    func tonConnect(_ provider: TonConnectProvider, failureManifest error: TonConnectError)
    func tonConnect(_ provider: TonConnectProvider, isConnectSuccessed: Bool)
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
    
    func tonConnect(message: Data, clientId: String, sessionId: String) {
        let url = "https://bridge.tonapi.io/bridge/message?client_id=\(clientId)&to=\(sessionId)&ttl=300"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = message.base64EncodedString().data(using: .utf8)
        
        AF.request(request).response { responseData in
            DispatchQueue.main.async {
                if let statusCode = responseData.response?.statusCode, statusCode == 200 {
                    SSEClient.shared.connectToSSE()
                    self.delegate?.tonConnect(self, isConnectSuccessed: true)
                } else {
                    self.delegate?.tonConnect(self, isConnectSuccessed: false)
                }
            }
        }
    }
}
