
import Foundation

final class Chest: Item {
    var name: String { "chest" }
    var isCollectible: Bool { false } // сундук нельзя взять

    var description: String { name }
}
