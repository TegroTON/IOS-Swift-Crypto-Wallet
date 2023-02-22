import IGListKit
import SwiftUI

class MainChartSection: ListSectionController {
    
    let template = MainChartCell()
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = CGSize(width: collectionContext!.containerSize.width, height: CGFloat.greatestFiniteMagnitude)
        configure(cell: template)
        template.frame.size = size
        template.layoutIfNeeded()
        
        return template.systemLayoutSizeFitting(size)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: MainChartCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    @discardableResult
    private func configure(cell: MainChartCell) -> MainChartCell {
        
//        cell.contentConfiguration = UIHostingConfiguration {
//            MainChartView()
//        }
        
        return cell
    }
}
