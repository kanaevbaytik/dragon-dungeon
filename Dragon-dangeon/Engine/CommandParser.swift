
struct CommandParser {
    static func parse(_ input: String) -> Command {
        let parts = input.lowercased().split(separator: " ")
        guard let first = parts.first else {
            return .unknown(input)
        }

        switch first {
        case "n": return .move(.north)
        case "s": return .move(.south)
        case "e": return .move(.east)
        case "w": return .move(.west)
        case "get":
            if parts.count > 1 {
                return .get(String(parts[1]))
            }
        case "drop":
            if parts.count > 1 {
                return .drop(String(parts[1]))
            }
        case "eat":
            if parts.count > 1 {
                return .eat(String(parts[1]))
            }
        case "open": return .open
        case "fight": return .fight
        case "help": return .help
        case "exit": return .exit
        default: break
        }

        return .unknown(input)
    }
}
