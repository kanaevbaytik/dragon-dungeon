
import Foundation

final class Gold: Item {
    let coins: Int
    
    init(coins: Int) {
        self.coins = coins
    }
    
    var name : String {
        return "gold (\(coins) coins"
    }
    
    var isCollectible: Bool { true }
    var description: String { name }
}
