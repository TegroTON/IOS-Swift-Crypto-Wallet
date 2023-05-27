import UIKit

class QRDetector {
    enum QRType {
        case transfer(address: String)
        case tonConnect(query: ConnectQuery)
        case none
    }
    
    private let detectorQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).QRDetector")
    private let qrCodeDetector: CIDetector?
    private let qrCodeDetectionOptions = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    
    init() {
        qrCodeDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: qrCodeDetectionOptions)
    }
    
    func detect(qr image: UIImage, completion: @escaping (QRType) -> Void) {
        detectorQueue.async {
            guard
                let ciImage = CIImage(image: image),
                let features = self.qrCodeDetector?.features(in: ciImage) as? [CIQRCodeFeature],
                !features.isEmpty
            else {
                completion(.none)
                return
            }
            
            for (index, qrCode) in features.enumerated() {
                guard let message = qrCode.messageString else {
                    if index == features.endIndex {
                        completion(.none)
                    }
                    continue
                }
                
                let components = URLComponents(string: message)
                let query = components?.queryItems
                let scheme = components?.scheme
                let path = components?.path
                let host = components?.host
                
                if host == "transfer" {
                    if var address = path {
                        address.removeFirst()
                        
                        completion(.transfer(address: address))
                        return
                    }
                }
                
                if scheme == "tc" || path == "/ton-connect" {
                    guard
                        let query = query,
                        let versionString = query.first(where: { $0.name == "v" })?.value as? String,
                        let version = Int(versionString),
                        let id = query.first(where: { $0.name == "id" })?.value as? String,
                        let requestJson = query.first(where: { $0.name == "r" })?.value as? String,
                        let jsonData = requestJson.data(using: .utf8),
                        let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                    else {
                        if index == features.endIndex {
                            completion(.none)
                        }
                        
                        return
                    }
                    
                    if let manifestUrl = jsonDictionary["manifestUrl"] as? String,
                       let itemsArray = jsonDictionary["items"] as? [[String: Any]]
                    {
                        var connectItems: [ConnectItem] = []
                        for item in itemsArray {
                            if let name = item["name"] as? String {
                                let payload = item["payload"] as? String
                                let connectItem = ConnectItem(name: name, payload: payload)
                                connectItems.append(connectItem)
                            }
                        }

                        let connectRequest = ConnectRequest(manifestUrl: manifestUrl, items: connectItems)
                        let connectQuery = ConnectQuery(version: version, request: connectRequest, id: id)
                        
                        completion(.tonConnect(query: connectQuery))
                    } else {
                        print("Invalid JSON or missing required fields")
                    }
                }
                
                if index == features.endIndex {
                    completion(.none)
                }
            }
        }
    }
    
}
