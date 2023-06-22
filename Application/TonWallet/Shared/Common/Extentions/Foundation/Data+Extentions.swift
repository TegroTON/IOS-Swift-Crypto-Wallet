import Foundation

extension Data {    
    init(randomBytes count: Int) {
        let QUOTE: Int = 1 << 16
        let data = Data(count: count)
        
        for i in stride(from: 0, to: count, by: QUOTE) {
            let subarrayCount = Swift.min(count - 1, QUOTE)
            var subarray = data.subdata(in: i..<i + subarrayCount)
            subarray.withUnsafeMutableBytes { mutableBytes in
                if let baseAddress = mutableBytes.baseAddress {
                    _ = SecRandomCopyBytes(kSecRandomDefault, subarrayCount, baseAddress)
                }
            }
        }
        
        self = data
    }
}
