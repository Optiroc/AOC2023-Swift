import Foundation

struct PuzzleInput {
    static func getInput(name: String) -> String {
        guard let url = Bundle.module.url(forResource: name, withExtension: "txt") else {
            fatalError("Input file '\(name)' not found")
        }
        return try! String(contentsOf: url)
    }

    static func getLines(name: String) -> [String] {
        getInput(name: name).components(separatedBy: "\n")
    }
}
