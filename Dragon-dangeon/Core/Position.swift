
import Foundation

struct Position: Equatable, Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    var description: String {
        "[\(x), \(y)]"
    }

    /// Возвращает новую позицию после перемещения в заданном направлении
    func moved(to direction: Direction) -> Position {
        let offset = direction.offset
        return Position(x: x + offset.dx, y: y + offset.dy)
    }

    /// Проверка, находится ли позиция в пределах карты
    func isValid(in width: Int, height: Int) -> Bool {
        return x >= 0 && x < height && y >= 0 && y < width
    }
}
