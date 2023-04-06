import UIKit

struct SettingsModel {
    enum CellType {
        case cell(image: UIImage?, title: String, subtitle: String? = nil, rightType: RightViewType)
        case button
    }
    
    enum RightViewType {
        case badge(Int)
        case label(String)
        case ´switch´
        case arrow
    }
    
    let type: CellType
}
