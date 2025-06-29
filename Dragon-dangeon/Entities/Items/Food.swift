
import Foundation

protocol Eatable {
    var restoreSteps: Int { get }
}

final class Food: Item, Eatable {
    var restoreSteps: Int
    
    init(restoreSteps: Int = 5) {
        self.restoreSteps = restoreSteps
    }
    
    var name: String { "food" }
    var isCollectible: Bool { true }
    var description: String { name }
}
