import UIKit

class PagingFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
 
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        scrollDirection = .horizontal
        minimumLineSpacing = 8
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        return rectAttributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let currentOffset = collectionView.contentOffset.x
        let targetOffset: CGPoint
                
        if velocity.x >= 0 {
            
            var offset = CGFloat.greatestFiniteMagnitude
            
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let attributes = layoutAttributesForItem(at: indexPath)!
                let itemOffset = attributes.frame.origin.x - sectionInset.left
                
                if itemOffset > currentOffset {
                    if abs(itemOffset - currentOffset) < abs(offset) {
                        offset = itemOffset - currentOffset
                    }
                }
            }
            
            targetOffset = CGPoint(x: currentOffset + offset, y: proposedContentOffset.y)
            
        } else {
            
            guard currentOffset > sectionInset.left else { return proposedContentOffset }
            
            var offset = CGFloat.greatestFiniteMagnitude
            
            for item in (0..<collectionView.numberOfItems(inSection: 0)).reversed() {
                let indexPath = IndexPath(item: item, section: 0)
                let attributes = layoutAttributesForItem(at: indexPath)!
                let itemOffset = attributes.frame.origin.x - sectionInset.left
                
                if itemOffset < currentOffset {
                    if abs(itemOffset - currentOffset) < abs(offset) {
                        offset = itemOffset - currentOffset
                    }
                }
            }
            
            targetOffset = CGPoint(x: currentOffset + offset, y: proposedContentOffset.y)
            
        }
        
        return targetOffset
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
