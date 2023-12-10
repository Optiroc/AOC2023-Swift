import FileUtils

enum Day06 {
    typealias Race = (time: Int, dist: Int)

    static func parse1(_ input: some Sequence<String>) -> [Race] {
        let z = input.map {
            $0.split(separator: " ").compactMap { Int($0) }
        }
        return zip(z[0], z[1]).map { $0 }
    }

    static func parse2(_ input: some Sequence<String>) -> Race {
        let n = input.map {
            $0.split(separator: " ")
                .compactMap { Int($0) }
                .reduce(into: "") { $0 += String($1) }
        }
        return (Int(n[0])!, Int(n[1])!)
    }

    static func waysToWin(_ race: Race) -> Int {
        var v = 0
        for hold in (1..<race.time) {
            if hold * (race.time - hold) > race.dist {
                v += 1
            } else if v > 0 {
                break
            }
        }
        return v
    }

    static func part1() throws {
        let sampleValue = parse1(try LineReader("day06_sample.txt", bundle: .module))
            .map { waysToWin($0) }
            .reduce(into: 1) { $0 *= $1 }
        print("06.1a Product of number of ways to beat record:", sampleValue)
        assert(288 == sampleValue)

        let puzzleValue = parse1(try LineReader("day06_input.txt", bundle: .module))
            .map { waysToWin($0) }
            .reduce(into: 1) { $0 *= $1 }
        print("06.1b Product of number of ways to beat record:", puzzleValue)
        assert(345015 == puzzleValue)
    }

    static func part2() throws {
        let sampleValue = waysToWin(parse2(try LineReader("day06_sample.txt", bundle: .module)))
        print("06.2a Number of ways to beat record:", sampleValue)
        assert(71503 == sampleValue)

        let puzzleValue = waysToWin(parse2(try LineReader("day06_input.txt", bundle: .module)))
        print("06.2b Number of ways to beat record:", puzzleValue)
        assert(42588603 == puzzleValue)
    }
}
