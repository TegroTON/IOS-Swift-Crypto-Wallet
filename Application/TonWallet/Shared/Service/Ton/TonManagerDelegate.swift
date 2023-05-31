import Foundation

protocol TonManagerDelegate: AnyObject {
    func ton(mnemonicsDidGenerated result: Result<[String], Error>)
    func ton(keyPairCalculated result: Result<TonKeyPair, Error>)
    func ton(stateInitDidCreated result: Result<String, Error>)
}

extension TonManagerDelegate {
    func ton(mnemonicsDidGenerated result: Result<[String], Error>) { }
    func ton(keyPairCalculated result: Result<TonKeyPair, Error>) { }
    func ton(stateInitDidCreated result: Result<String, Error>) { }
}
