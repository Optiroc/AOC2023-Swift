enum Day01 {
    static let numeralDigits = [
        "1": 1,
        "2": 2,
        "3": 3,
        "4": 4,
        "5": 5,
        "6": 6,
        "7": 7,
        "8": 8,
        "9": 9,
    ]

    static let allDigits = [
        "1": 1, "one": 1,
        "2": 2, "two": 2,
        "3": 3, "three": 3,
        "4": 4, "four": 4,
        "5": 5, "five": 5,
        "6": 6, "six": 6,
        "7": 7, "seven": 7,
        "8": 8, "eight": 8,
        "9": 9, "nine": 9
    ]

    static func getNumber(_ input: String, onlyNumerals: Bool = true) -> Int {
        let digits = onlyNumerals ? numeralDigits : allDigits
        let matches = input.firstAndLastOccurence(of: digits.keys)!
        return digits[matches.1]! + digits[matches.0]! * 10
    }

    static func part1() {
        let sampleValue = PuzzleInput.getLines(name: "day01_sample1")
            .filter { !$0.isEmpty }
            .reduce(into: 0) { $0 += getNumber($1, onlyNumerals: true) }
        print("01.1a Calibration value in sample:", sampleValue)

        let puzzleValue = PuzzleInput.getLines(name: "day01_input")
            .filter { !$0.isEmpty }
            .reduce(into: 0) { $0 += getNumber($1, onlyNumerals: true) }
        print("01.1b Calibration value in puzzle:", puzzleValue)

        assert(142 == sampleValue)
        assert(54927 == puzzleValue)
    }

    static func part2() {
        let sampleValue = PuzzleInput.getLines(name: "day01_sample2")
            .filter { !$0.isEmpty }
            .reduce(into: 0) { $0 += getNumber($1, onlyNumerals: false) }
        print("01.2a Calibration value in sample:", sampleValue)

        let puzzleValue = PuzzleInput.getLines(name: "day01_input")
            .filter { !$0.isEmpty }
            .reduce(into: 0) { $0 += getNumber($1, onlyNumerals: false) }
        print("01.2b Calibration value in puzzle:", puzzleValue)

        assert(281 == sampleValue)
        assert(54581 == puzzleValue)
    }
}
