@main
struct AOC2023 {
    static func main() {
        let measure = Measure()
        do {
            try runAll()
        } catch {
            fatalError(error.localizedDescription)
        }
        print("Time: \(measure.elapsed)s")
    }

    static func runAll() throws {
        try Day01.part1()
        try Day01.part2()
        try Day02.part1()
        try Day02.part2()
        try Day03.part1()
        try Day03.part2()
    }
}
