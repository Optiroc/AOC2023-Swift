import Foundation

func readLines(from resourceName: String) -> AsyncLineSequence<URL.AsyncBytes> {
    guard let url = Bundle.module.url(forResource: resourceName, withExtension: "txt") else {
        fatalError("Input file '\(resourceName)' not found")
    }
    return url.lines
}

struct Measure {
    private(set) var start = ProcessInfo.processInfo.systemUptime

    var elapsed: Double { ProcessInfo.processInfo.systemUptime - start }

    mutating func reset() { start = ProcessInfo.processInfo.systemUptime }
}
