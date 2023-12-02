import Foundation

struct Measure {
    private(set) var start = ProcessInfo.processInfo.systemUptime

    var elapsed: Double { ProcessInfo.processInfo.systemUptime - start }

    mutating func reset() { start = ProcessInfo.processInfo.systemUptime }
}
