
import Foundation

final class Maze {
    private(set) var rooms: [[Room]] = []
    let width: Int
    let height: Int

    private(set) var startX: Int = 0
    private(set) var startY: Int = 0

    init(width: Int, height: Int) {
        self.width = width
        self.height = height

        generateRooms()
        generateDoors()
        placeKeyAndChest()
        placeStartPosition()
        placeRandomItems()
    }

    private func generateRooms() {
        rooms = (0..<height).map { x in
            (0..<width).map { y in
                Room(position: Position(x: x, y: y))
            }
        }
    }

    private func generateDoors() {
        for x in 0..<height {
            for y in 0..<width {
                let pos = Position(x: x, y: y)
                var doors: [Direction] = []

                if pos.moved(to: .north).isValid(in: width, height: height) { doors.append(.north) }
                if pos.moved(to: .south).isValid(in: width, height: height) { doors.append(.south) }
                if pos.moved(to: .east).isValid(in: width, height: height) { doors.append(.east) }
                if pos.moved(to: .west).isValid(in: width, height: height) { doors.append(.west) }

                rooms[x][y].doors = doors
            }
        }
    }

    private func placeKeyAndChest() {
        let keyPos = randomEmptyPosition()
        rooms[keyPos.x][keyPos.y].addItem(Key())

        var chestPos: Position
        repeat {
            chestPos = randomEmptyPosition()
        } while chestPos == keyPos

        rooms[chestPos.x][chestPos.y].addItem(Chest())
    }

    private func placeStartPosition() {
        var pos: Position
        repeat {
            pos = randomEmptyPosition()
        } while rooms[pos.x][pos.y].containsItem(ofType: Key.self) || rooms[pos.x][pos.y].containsItem(ofType: Chest.self)

        startX = pos.x
        startY = pos.y
    }

    private func placeRandomItems() {
        for _ in 0..<(width * height / 4) {
            let pos = randomEmptyPosition()
            let room = rooms[pos.x][pos.y]

            let roll = Int.random(in: 0..<100)

            switch roll {
            case 0..<30:
                room.addItem(Food())
            case 30..<50:
                room.addItem(Sword())
            case 50..<90:
                room.addItem(Gold(coins: Int.random(in: 50...200)))
            case 90..<95:
                room.isDark = true
            default:
                break
            }

            // Дополнительно с шансом 5% — монстр
            if Int.random(in: 0..<100) < 5 {
                room.monsterName = ["goblin", "orc", "skeleton", "demon"].randomElement()
                print("💀 Monster spawned at [\(pos.x), \(pos.y)] — \(room.monsterName!)")
            }
        }
    }


    private func randomEmptyPosition() -> Position {
        var pos: Position
        repeat {
            let x = Int.random(in: 0..<height)
            let y = Int.random(in: 0..<width)
            pos = Position(x: x, y: y)
        } while !rooms[pos.x][pos.y].items.isEmpty
        return pos
    }

    func room(at position: Position) -> Room? {
        guard position.isValid(in: width, height: height) else { return nil }
        return rooms[position.x][position.y]
    }

    func updateRoom(_ room: Room) {
        rooms[room.position.x][room.position.y] = room
    }
}
