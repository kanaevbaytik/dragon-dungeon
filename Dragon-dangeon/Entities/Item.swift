
import Foundation

protocol Item: AnyObject, CustomStringConvertible {
    var name: String { get }
    var isCollectible: Bool { get }
}
