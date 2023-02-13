import Foundation

protocol TonManagerDelegate: AnyObject {
    func ton(mnemonicsDidGenerated result: Result<[String], Error>)
    func ton(keyPairCalculated result: Result<TonKeyPair, Error>)
}

extension TonManagerDelegate {
    func ton(mnemonicsDidGenerated result: Result<[String], Error>) { }
    func ton(keyPairCalculated result: Result<TonKeyPair, Error>) { }
}