
import Foundation

enum Command: Equatable {
    case move(Direction)
    case get(String)
    case drop(String)
    case eat(String)
    case open
    case fight
    case unknown(String)
    case help
}
