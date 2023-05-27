import UIKit

protocol TonConnectProviderDelegate: AnyObject {
    
}

class TonConnectProvider {
    
    weak var delegate: TonConnectProviderDelegate?
    
}
