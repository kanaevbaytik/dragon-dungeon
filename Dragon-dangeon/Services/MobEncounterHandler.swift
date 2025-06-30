
import Foundation

final class MobEncounterHandler {
    private let player: Player
    private let fromPosition: Position
    private let monsterName: String
    private let timeout: TimeInterval = 5.0

    init(player: Player, fromPosition: Position, monsterName: String) {
        self.player = player
        self.fromPosition = fromPosition
        self.monsterName = monsterName
    }

    func engage(_ inputHandler: () -> String?) {
        print("⚠️  There is an evil \(monsterName) in the room!")
        print("You have \(Int(timeout)) seconds to act!")

        let startTime = Date()

        while Date().timeIntervalSince(startTime) < timeout {
            print("\n> ", terminator: "")
            if let input = inputHandler(), !input.isEmpty {
                resolveCombat(for: input)
                return
            }
        }

        // Не успел ввести команду — монстр атакует
        applyMonsterPenalty()
    }

    private func resolveCombat(for input: String) {
        let outcome = Int.random(in: 0..<3)

        switch outcome {
        case 0:
            applyPenalty()
            print("💥 The monster attacked you and threw you back!")
            player.teleport(to: fromPosition)
        case 1:
            applyPenalty()
            print("🩸 You acted, but the monster scratched you!")
        case 2:
            print("🛡 You managed to act in time and avoid the attack!")
        default:
            break
        }
    }

    private func applyMonsterPenalty() {
        print("💀 You were too slow! The monster attacked!")
        applyPenalty()
        player.teleport(to: fromPosition)
    }

    private func applyPenalty() {
        let lost = max(1, player.stepsLeft / 10)
        player.loseSteps(lost)
    }
}
