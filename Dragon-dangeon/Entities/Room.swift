
import Foundation

final class Room {
    let position: Position
    var doors: [Direction]
    private(set) var items: [Item]
    var isDark: Bool
    var isIlluminated: Bool
    var monsterName: String?

    init(position: Position,
         doors: [Direction] = [],
         items: [Item] = [],
         isDark: Bool = false,
         isIlluminated: Bool = false,
         monsterName: String? = nil) {
        self.position = position
        self.doors = doors
        self.items = items
        self.isDark = isDark
        self.isIlluminated = isIlluminated
        self.monsterName = monsterName
    }

    var isVisible: Bool {
        return !isDark || isIlluminated
    }

    func addItem(_ item: Item) {
        items.append(item)
    }

    func removeItem(named name: String) -> Item? {
        if let index = items.firstIndex(where: { $0.name.lowercased() == name.lowercased() }) {
            return items.remove(at: index)
        }
        return nil
    }

    func item(named name: String) -> Item? {
        return items.first { $0.name.lowercased() == name.lowercased() }
    }

    func containsItem<T: Item>(ofType type: T.Type) -> Bool {
        return items.contains { $0 is T }
    }


    var description: String {
        var output = "You are in the room \(position).\n"

        if isDark && !isIlluminated {
            output += "Can't see anything in this dark place!"
            return output
        }

        output += "There are \(doors.count) doors: "
        output += doors.map { $0.description }.joined(separator: ", ") + ".\n"

        if items.isEmpty {
            output += "Items in the room: none.\n"
        } else {
            output += "Items in the room: " + items.map { $0.description }.joined(separator: ", ") + ".\n"
        }

        if let mob = monsterName {
            output += "There is an evil \(mob) in the room!\n"
        }

        return output
    }
}
