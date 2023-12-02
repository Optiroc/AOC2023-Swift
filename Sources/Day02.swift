import Foundation
import FileUtils

enum Day02 {
    struct Cubes {
        let red: Int
        let green: Int
        let blue: Int

        static func from(_ str: Substring) -> Cubes {
            var d = [String: Int]()
            for e in str.split(separator: ", ") {
                let c = e.split(separator: " ")
                d[String(c[1])] = Int(c[0])!
            }
            return Cubes(red: d["red"] ?? 0, green: d["green"] ?? 0, blue: d["blue"] ?? 0)
        }
    }

    struct Game {
        let index: Int
        let hands: [Cubes]

        var cubesNeeded: Cubes {
            hands.reduce(into: Cubes(red: 0, green: 0, blue: 0)) {
                $0 = Cubes(
                    red: max($0.red, $1.red),
                    green: max($0.green, $1.green),
                    blue: max($0.blue, $1.blue)
                )
            }
        }

        static func from(_ str: String) -> Game {
            let g = str.split(separator: ": ")
            return Game(
                index: Int(g[0].split(separator: " ")[1])!,
                hands: g[1].split(separator: "; ").map { Cubes.from($0) }
            )
        }
    }

    static func id(_ str: String, max: Cubes) -> Int {
        let game = Game.from(str)
        return game.hands.allSatisfy {
            $0.red <= max.red && $0.green <= max.green && $0.blue <= max.blue
        } ? game.index : 0
    }

    static func power(_ str: String) -> Int {
        let cubes = Game.from(str).cubesNeeded
        return cubes.red * cubes.green * cubes.blue
    }

    static func part1() throws {
        let sampleValue = try LineReader("day02_sample.txt", bundle: .module)
            .filter { !$0.isEmpty }
            .reduce(into: 0) { $0 += id($1, max: Cubes(red: 12, green: 13, blue: 14)) }
        print("01.1a Sum of possible game IDs in sample:", sampleValue)

        let puzzleValue = try LineReader("day02_input.txt", bundle: .module)
            .filter { !$0.isEmpty }
            .reduce(into: 0) { $0 += id($1, max: Cubes(red: 12, green: 13, blue: 14)) }
        print("01.1b Sum of possible game IDs in puzzle:", puzzleValue)

        assert(8 == sampleValue)
        assert(2600 == puzzleValue)
    }

    static func part2() throws {
        let sampleValue = try LineReader("day02_sample.txt", bundle: .module)
            .filter { !$0.isEmpty }
            .reduce(into: 0) { $0 += power($1) }
        print("01.2a Sum of game powers in sample:", sampleValue)

        let puzzleValue = try LineReader("day02_input.txt", bundle: .module)
            .filter { !$0.isEmpty }
            .reduce(into: 0) { $0 += power($1) }
        print("01.2b Sum of game powers in puzzle:", puzzleValue)

        assert(2286 == sampleValue)
        assert(86036 == puzzleValue)
    }
}
