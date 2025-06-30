import Foundation

enum ConsoleColor: String {
    case reset = "\u{001B}[0m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case blue = "\u{001B}[0;34m"
    case gray = "\u{001B}[0;37m"
    case yellow = "\u{001B}[0;33m"
    case magenta = "\u{001B}[0;35m"
    case boldRed = "\u{001B}[1;31m"
}

func printColor(_ text: String, color: ConsoleColor) {
    print("\(color.rawValue)\(text)\(ConsoleColor.reset.rawValue)")
}

func printSuccess(_ text: String) {
    printColor(text, color: .green)
}

func printError(_ text: String) {
    printColor(text, color: .red)
}

func printInfo(_ text: String) {
    printColor(text, color: .blue)
}

func printGray(_ text: String) {
    printColor(text, color: .gray)
}

func printVictory(_ text: String) {
    printColor(text, color: .magenta) // или .yellow
}

func printDeath(_ text: String) {
    printColor(text, color: .boldRed)
}
