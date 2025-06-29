
import Foundation

final class MazeValidator {
    private let maze: Maze
    private var visited: Set<Position> = []

    init(maze: Maze) {
        self.maze = maze
    }

    func isReachableToGoal(from start: Position, maxSteps: Int) -> Bool {
        visited = []
        var queue: [(position: Position, steps: Int)] = [(start, 0)]
        var foundKey = false
        var foundChest = false

        while !queue.isEmpty {
            let (currentPos, steps) = queue.removeFirst()
            guard !visited.contains(currentPos), steps <= maxSteps else { continue }
            visited.insert(currentPos)

            guard let room = maze.room(at: currentPos) else { continue }

            if room.containsItem(ofType: Key.self) {
                foundKey = true
            }
            if room.containsItem(ofType: Chest.self) {
                foundChest = true
            }
            if foundKey && foundChest {
                return true
            }

            for direction in room.doors {
                let next = currentPos.moved(to: direction)
                if next.isValid(in: maze.width, height: maze.height) {
                    queue.append((next, steps + 1))
                }
            }
        }

        return false
    }
}

