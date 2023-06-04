import Foundation

extension Data {
    init?(hexString: String) {
        // Remove any spaces or other non-hex characters
        let cleanedString = hexString.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        
        // Ensure the string has an even number of characters
        guard cleanedString.count % 2 == 0 else {
            return nil
        }
        
        // Convert each pair of characters to a byte and create a Data object
        var data = Data(capacity: cleanedString.count / 2)
        var index = cleanedString.startIndex
        while index < cleanedString.endIndex {
            let byteString = cleanedString[index..<cleanedString.index(index, offsetBy: 2)]
            if let byte = UInt8(byteString, radix: 16) {
                data.append(byte)
            } else {
                return nil
            }
            index = cleanedString.index(index, offsetBy: 2)
        }
        self = data
    }
    
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
    
    func bytesToBase64() -> String {
        var result = ""
        var i = 0
        let l = self.count
        let base64abc = getBase64abc()
        
        for i in stride(from: 2, to: l, by: 3) {
            result += String(base64abc[Int(self[i - 2]) >> 2])
            result += String(base64abc[((Int(self[i - 2]) & 0x03) << 4) | (Int(self[i - 1]) >> 4)])
            result += String(base64abc[((Int(self[i - 1]) & 0x0f) << 2) | (Int(self[i]) >> 6)])
            result += String(base64abc[Int(self[i]) & 0x3f])
        }
        
        if i == l + 1 {
            // 1 octet missing
            result += String(base64abc[Int(self[i - 2]) >> 2])
            result += String(base64abc[(Int(self[i - 2]) & 0x03) << 4])
            result += "=="
        }
        
        if i == l {
            // 2 octets missing
            result += String(base64abc[Int(self[i - 2]) >> 2])
            result += String(base64abc[((Int(self[i - 2]) & 0x03) << 4) | (Int(self[i - 1]) >> 4)])
            result += String(base64abc[(Int(self[i - 1]) & 0x0f) << 2])
            result += "="
        }
        
        return result
    }
    
    private func getBase64abc() -> [Character] {
        var abc = [Character]()
        let A = Character("A").asciiValue!
        let a = Character("a").asciiValue!
        let n = Character("0").asciiValue!
        
        for i in 0..<26 {
            abc.append(Character(UnicodeScalar(A + UInt8(i))))
        }
        
        for i in 0..<26 {
            abc.append(Character(UnicodeScalar(a + UInt8(i))))
        }
        
        for i in 0..<10 {
            abc.append(Character(UnicodeScalar(n + UInt8(i))))
        }
        
        abc.append("+")
        abc.append("/")
        
        return abc
    }
}
