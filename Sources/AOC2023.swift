@main
struct AOC2023 {
    static func main() async {
        do {
            try await Day01.part1()
            try await Day01.part2()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
