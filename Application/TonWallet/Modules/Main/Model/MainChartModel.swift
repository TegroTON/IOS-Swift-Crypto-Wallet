import IGListDiffKit

class MainChartModel {
    let test: String
    
    init(test: String) {
        self.test = test
    }
}

// MARK: - ListDiffable

extension MainChartModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return test as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else { return false }
        
        return object.test == test
    }
}
