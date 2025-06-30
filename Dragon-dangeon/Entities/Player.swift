
import Foundation

final class Player {
    private(set) var position: Position
    private(set) var stepsLeft: Int
    private(set) var inventory: [Item] = []
    private(set) var gold: Int = 0

    init(startPosition: Position, steps: Int) {
        self.position = startPosition
        self.stepsLeft = steps
    }

    func move(to direction: Direction) {
        position = position.moved(to: direction)
        stepsLeft -= 1
    }

    func addItem(_ item: Item) {
        if let goldItem = item as? Gold {
            gold += goldItem.coins
            return
        }
        inventory.append(item)
    }

    func dropItem(named name: String) -> Item? {
        if let index = inventory.firstIndex(where: { $0.name.lowercased() == name.lowercased() }) {
            return inventory.remove(at: index)
        }
        return nil
    }

    func hasItem<T: Item>(ofType type: T.Type) -> Bool {
        return inventory.contains { $0 is T }
    }

    func item(named name: String) -> Item? {
        return inventory.first { $0.name.lowercased() == name.lowercased() }
    }

    func eatItem(named name: String) -> Bool {
        guard let index = inventory.firstIndex(where: { $0.name.lowercased() == name.lowercased() }) else {
            return false
        }

        guard let eatable = inventory[index] as? Eatable else {
            return false
        }

        stepsLeft += eatable.restoreSteps
        inventory.remove(at: index)
        return true
    }
    
    func loseSteps(_ count: Int) {
        stepsLeft = max(0, stepsLeft - count)
    }
    
    func teleport(to newPosition: Position) {
        self.position = newPosition
    }
    
    func hasSword() -> Bool {
        inventory.contains { $0 is Sword }
    }
}
