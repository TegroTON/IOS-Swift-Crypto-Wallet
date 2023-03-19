import UIKit

enum FontWeight: String {
    case bold = "-Bold"
    case extraBold = "-ExtraBold"
    case medium = "-Medium"
    case regular = "-Regular"
    case semiBold = "-SemiBold"
    case black = "-Black"
    case italic = "-Italic"
}

extension UIFont {
    class func montserratFont(ofSize fontSize: CGFloat, weight: FontWeight) -> UIFont {
        let name = "Montserrat" + weight.rawValue
        return UIFont(name: name, size: fontSize)!
    }
    
    class func rubicFont(ofSize fontSize: CGFloat, weight: FontWeight) -> UIFont {
        let name = "Rubik" + weight.rawValue
        return UIFont(name: name, size: fontSize)!
    }
    
    class func interFont(ofSize fontSize: CGFloat, weight: FontWeight) -> UIFont {
        let name = "Inter" + weight.rawValue
        return UIFont(name: name, size: fontSize)!
    }
}
