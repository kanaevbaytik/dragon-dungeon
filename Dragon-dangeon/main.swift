
import Foundation

print("🌀 Welcome to the Dragon’s Dungeon!")
print("Enter width of the maze (min 3): ", terminator: "")
let width = Int(readLine() ?? "") ?? 5

print("Enter height of the maze (min 3): ", terminator: "")
let height = Int(readLine() ?? "") ?? 5

print("Enter number of steps (e.g. 20): ", terminator: "")
let steps = Int(readLine() ?? "") ?? 20

let maze = Maze(width: max(3, width), height: max(3, height))
let start = Position(x: maze.startX, y: maze.startY)
let player = Player(startPosition: start, steps: steps)
let engine = GameEngine(maze: maze, player: player)

engine.start()
