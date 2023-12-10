import FileUtils
import OptiTypes

enum Day03 {
    static func sumParts(_ input: Matrix<Character>) -> Int {
        input.continuousMatricesSatisfying { $0.isNumber }
            .filter {
                !$0.offset(edges: .one, clamped: true)
                    .filter { $0 != "." && !$0.isNumber }
                    .isEmpty
            }
            .map { Int($0.string)! }
            .reduce(0, +)
    }

    static func sumGearRatios(_ input: Matrix<Character>) -> Int {
        let numbers = input.continuousMatricesSatisfying { $0.isNumber }

        return input.continuousMatricesSatisfying { $0 == "*" }
            .map {
                $0.offset(edges: .one)
            }
            .reduce(into: [[Matrix<Character>]]()) { acc, e in
                let og = numbers.filter { e.view.overlaps(with: $0.view) }
                if og.count == 2 { acc.append(og) }
            }
            .map {
                $0.map { Int($0.string)! }
            }
            .reduce(into: 0) {
                $0 += $1[0] * $1[1]
            }
    }

    static func part1() throws {
        let sampleValue = sumParts(try Matrix<Character>.from(sequence: LineReader("day03_sample.txt", bundle: .module)))
        print("03.1a Sum of part IDs in sample:", sampleValue)
        assert(4361 == sampleValue)

        let puzzleValue = sumParts(try Matrix<Character>.from(sequence: LineReader("day03_input.txt", bundle: .module)))
        print("03.1b Sum of part IDs in puzzle:", puzzleValue)
        assert(520135 == puzzleValue)
    }

    static func part2() throws {
        let sampleValue = sumGearRatios(try Matrix<Character>.from(sequence: LineReader("day03_sample.txt", bundle: .module)))
        print("03.2a Sum of gear ratios in sample:", sampleValue)
        assert(467835 == sampleValue)

        let puzzleValue = sumGearRatios(try Matrix<Character>.from(sequence: LineReader("day03_input.txt", bundle: .module)))
        print("03.2b Sum of gear ratios in puzzle:", puzzleValue)
        assert(72514855 == puzzleValue)
    }
}
