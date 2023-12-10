import Collections
import FileUtils

enum Day04 {
    static func points(_ card: String) -> (Int, Int) {
        let sets = card.split(separator: ":")[1].split(separator: "|")
            .map {
                $0.split(separator: " ").map { Int(String($0))! }
            }.map {
                Set($0)
            }
        let matches = sets[0].intersection(sets[1]).count
        return (matches, (matches > 0 ? 1 : 0) << max(0, matches - 1))
    }

    static func count(cards: some Sequence<String>) -> Int {
        var total = 0
        var deck = Deque<Int>()
        for card in cards {
            let amount = 1 + (deck.isEmpty ? 0 : deck.removeFirst())
            total += amount
            for i in 0..<points(card).0 {
                if deck.count - 1 >= i {
                    deck[i] = deck[i] + amount
                } else {
                    deck.append(amount)
                }
            }
        }
        return total
    }

    static func part1() throws {
        let sampleValue = try LineReader("day04_sample.txt", bundle: .module)
            .map { points($0) }
            .reduce(into: 0) { $0 += $1.1 }
        print("04.1a Sum of cards in sample:", sampleValue)
        assert(13 == sampleValue)

        let puzzleValue = try LineReader("day04_input.txt", bundle: .module)
            .map { points($0) }
            .reduce(into: 0) { $0 += $1.1 }
        print("04.1b Sum of cards in puzzle:", puzzleValue)
        assert(21821 == puzzleValue)
    }

    static func part2() throws {
        let sampleValue = count(cards: try LineReader("day04_sample.txt", bundle: .module))
        print("04.2a Total cards in sample:", sampleValue)
        assert(30 == sampleValue)

        let puzzleValue = count(cards: try LineReader("day04_input.txt", bundle: .module))
        print("04.2b Total cards in puzzle:", puzzleValue)
        assert(5539496 == puzzleValue)
    }
}
