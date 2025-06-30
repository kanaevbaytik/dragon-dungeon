
import Foundation

final class GameEngine {
    private let maze: Maze
    private let player: Player
    private var isRunning = true

    init(maze: Maze, player: Player) {
        self.maze = maze
        self.player = player
    }

    func start() {
        print("Welcome to the Dragon’s Dungeon!")
        print("Type 'help' to see available commands.")
        print("Find the key and the chest to retrieve the Holy Grail.\n")
        describeCurrentRoom()

        while isRunning && player.stepsLeft > 0 {
            print("\n> ", terminator: "")
            guard let input = readLine() else { continue }

            let command = CommandParser.parse(input)
            handle(command)
        }

        if player.stepsLeft <= 0 {
            print("💀 You ran out of steps and died in the dungeon.")
        }
    }

    private func handle(_ command: Command) {
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
            print("⚔️ You try to fight, but nothing happens. (Not implemented)")
        case .help:
            print("""
            📜 Available commands:
            - n, s, e, w         — Move North, South, East, West
            - get [item]         — Pick up an item
            - drop [item]        — Drop an item from inventory
            - eat [item]         — Eat food to restore steps
            - open               — Open chest (if you have a key)
            - help               — Show this help message
            """)
        case .unknown(let raw):
            print("Unknown command: \(raw)")
        }
    }

    private func movePlayer(to direction: Direction) {
        guard let currentRoom = maze.room(at: player.position) else { return }
        guard currentRoom.doors.contains(direction) else {
            print("🚪 There's no door to the \(direction.description).")
            return
        }

        let newPosition = player.position.moved(to: direction)
        guard let newRoom = maze.room(at: newPosition) else {
            print("You hit a wall.")
            return
        }

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

        print(room.description)
        print("Inventory: \(player.inventory.map { $0.name }.joined(separator: ", "))")
        print("Gold: \(player.gold) | Steps left: \(player.stepsLeft)")
    }

    private func pickUpItem(named name: String) {
        guard let room = maze.room(at: player.position) else { return }
        guard let item = room.item(named: name) else {
            print("❌ No item named '\(name)' in this room.")
            return
        }

        if item.isCollectible {
            player.addItem(item)
            room.removeItem(named: name)
            print("🧾 You picked up the \(item.name).")
        } else {
            print("❌ You can't pick up the \(item.name).")
        }
    }

    private func dropItem(named name: String) {
        guard let item = player.dropItem(named: name) else {
            print("❌ No such item in inventory.")
            return
        }

        maze.room(at: player.position)?.addItem(item)
        print("🧾 You dropped the \(item.name).")
    }

    private func eatItem(named name: String) {
        if player.eatItem(named: name) {
            print("🍖 You ate the \(name) and feel stronger!")
        } else {
            print("❌ You can't eat '\(name)'.")
        }
    }

    private func openChest() {
        guard let room = maze.room(at: player.position) else { return }

        if !room.containsItem(ofType: Chest.self) {
            print("❌ There is no chest here.")
            return
        }

        if player.hasItem(ofType: Key.self) {
            print("🎉 You opened the chest and found the Holy Grail! YOU WIN!")
            isRunning = false
        } else {
            print("🔒 The chest is locked. You need a key.")
        }
    }
}
