
import Foundation

final class GameEngine {
    private let maze: Maze
    private let player: Player
    private var isRunning = true
    
    private var lastPosition: Position?

    init(maze: Maze, player: Player) {
        self.maze = maze
        self.player = player
    }

    func start() {
        printInfo("Welcome to the Dragon’s Dungeon!")
        printInfo("Type 'help' to see available commands.")
        printInfo("Find the key and the chest to retrieve the Holy Grail.\n")
        describeCurrentRoom()

        while isRunning && player.stepsLeft > 0 {
            print("\n> ", terminator: "")
            guard let input = readLine() else { continue }

            let command = CommandParser.parse(input)
            handle(command)
        }

        if player.stepsLeft <= 0 {
            printDeath("💀 You ran out of steps and died in the dungeon.")
        }
    }

    private func handle(_ command: Command) {
        guard let room = maze.room(at: player.position) else { return }

        let canAct = room.isVisible
        let allowedWhileDark: [Command] = [.move(.north), .move(.south), .move(.east), .move(.west), .help]

        if !canAct && !allowedWhileDark.contains(where: {
            if case let .move(dir) = $0, case let .move(inputDir) = command {
                return dir == inputDir
            }
            return $0 == command
        }) {
            printGray("🌑 It's too dark to do that. You can only move or type 'help'.")
            return
        }

        switch command {
        case .move(let direction):
            movePlayer(to: direction)
        case .get(let name):
            pickUpItem(named: name)
        case .drop(let name):
            dropItem(named: name)
        case .eat(let name):
            eatItem(named: name)
        case .open:
            openChest()
        case .fight:
            printInfo("⚔️ You try to fight, but nothing happens. (Not implemented)")
        case .help:
            printInfo("""
        📜 Available commands:
        - n, s, e, w         — Move North, South, East, West
        - get [item]         — Pick up an item (e.g. get gold)
        - drop [item]        — Drop an item from inventory (e.g. drop torchlight)
        - eat [item]         — Eat food to restore steps
        - open               — Open chest (if you have a key)
        - fight              — Fight a monster (if you have a sword)
        - help               — Show this help message
        - exit               — Exit the game

        💡 Tips:
        - If you enter a dark room, bring a torchlight to illuminate it.
        - Fight monsters only if you have a sword.
        - Gold adds coins automatically when picked up.
        """)
        case .fight:
            guard let room = maze.room(at: player.position),
                  let monster = room.monsterName else {
                printGray("❌ There is no one to fight here.")
                return
            }

            guard player.hasSword() else {
                printGray("🗡 You have no sword to fight the \(monster)!")
                return
            }

            // Условия боя (случайный исход)
            let roll = Int.random(in: 0..<3)
            switch roll {
            case 0:
                // Победа без урона
                room.removeMonster()
                printSuccess("⚔️ You defeated the \(monster) with ease!")
            case 1:
                // Победа с урона
                room.removeMonster()
                player.loseSteps(max(1, player.stepsLeft / 10))
                printGray("⚔️ You defeated the \(monster), but you took a hit!")
            case 2:
                // Монстр отбрасывает игрока назад
                player.loseSteps(max(1, player.stepsLeft / 10))
                if let last = lastPosition {
                player.teleport(to: last)
                printGray("↩️ You were pushed back to your previous position.")
                } else {
                printError("⚠️ Error: No last position to teleport to.")
                }
                printError("💥 The \(monster) hit you hard and threw you back!")
            default:
                break
            }
        case .unknown(let raw):
            printError("Unknown command: \(raw)")
        case .exit:
            printInfo("👋 You chose to exit the game. See you next time!")
            isRunning = false
        default:
            break
        }
        
    }

    private func movePlayer(to direction: Direction) {
        guard let currentRoom = maze.room(at: player.position) else { return }
        guard currentRoom.doors.contains(direction) else {
            printError("🚪 There's no door to the \(direction.description).")
            return
        }

        let newPosition = player.position.moved(to: direction)
        guard let newRoom = maze.room(at: newPosition) else {
            printGray("You hit a wall.")
            return
        }
        lastPosition = player.position
        player.move(to: direction)
        guard let newRoom = maze.room(at: player.position) else { return }
        if let mob = newRoom.monsterName {
            let handler = MobEncounterHandler(player: player, fromPosition: currentRoom.position, monsterName: mob)
            handler.engage { readLine() }
        }
        describeCurrentRoom()
    }

    private func describeCurrentRoom() {
        guard let room = maze.room(at: player.position) else { return }
        
        if room.isDark && !room.isIlluminated && player.hasItem(ofType: Torchlight.self) {
            room.isIlluminated = true
        }
        
        if let mob = room.monsterName {
            printInfo("⚠️ There's a monster here! You can use 'fight' if you have a sword.")
        }

        if room.items.contains(where: { $0 is Gold }) {
            printInfo("💰 You see gold! Use 'get gold' to collect it.")
        }

        if room.isDark && !room.isIlluminated {
            printGray("🌑 It's dark here. If you have a torchlight, you can illuminate the room.")
        }

        print(room.description)
        printInfo("Inventory: \(player.inventory.map { $0.name }.joined(separator: ", "))")
        printInfo("Gold: \(player.gold) | Steps left: \(player.stepsLeft)")
    }

    private func pickUpItem(named name: String) {
        guard let room = maze.room(at: player.position) else { return }
        guard let item = room.item(named: name) else {
            printError("❌ No item named '\(name)' in this room.")
            return
        }

        if item.isCollectible {
            player.addItem(item)
            room.removeItem(named: name)
            printSuccess("🧾 You picked up the \(item.name).")
        } else {
            printError("❌ You can't pick up the \(item.name).")
        }
    }

    private func dropItem(named name: String) {
        guard let item = player.dropItem(named: name) else {
            printError("❌ No such item in inventory.")
            return
        }

        maze.room(at: player.position)?.addItem(item)
        printSuccess("🧾 You dropped the \(item.name).")
        if item is Torchlight {
            maze.room(at: player.position)?.isIlluminated = true
            printSuccess("💡 The room is now illuminated by the torchlight.")
        }

    }

    private func eatItem(named name: String) {
        if player.eatItem(named: name) {
            printSuccess("🍖 You ate the \(name) and feel stronger!")
        } else {
            printError("❌ You can't eat '\(name)'.")
        }
    }

    private func openChest() {
        guard let room = maze.room(at: player.position) else { return }

        if !room.containsItem(ofType: Chest.self) {
            printError("❌ There is no chest here.")
            return
        }

        if player.hasItem(ofType: Key.self) {
            printVictory("🎉 You opened the chest and found the Holy Grail! YOU WIN!")
            isRunning = false
        } else {
            printError("🔒 The chest is locked. You need a key.")
        }
    }
}
