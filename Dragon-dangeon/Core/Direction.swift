
import Foundation

enum Direction: CaseIterable, CustomStringConvertible {
    case north
    case south
    case east
    case west

    var description: String {
        switch self {
        case .north: return "N"
        case .south: return "S"
        case .east:  return "E"
        case .west:  return "W"
        }
    }

    /// Смещение координат в зависимости от направления
    var offset: (dx: Int, dy: Int) {
        switch self {
        case .north: return (-1, 0)
        case .south: return (1, 0)
        case .east:  return (0, 1)
        case .west:  return (0, -1)
        }
    }

    /// Возвращает противоположное направление
    var opposite: Direction {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east:  return .west
        case .west:  return .east
        }
    }
}
