import Foundation

enum FileReaderError: Error {
    case resourceNotFound
    case failedToOpen
}

final class FileReader {
    let encoding: String.Encoding
    let delimiter: Data
    let bufferSize: Int
    let fileHandle: FileHandle
    var buffer: Data
    var atEOF: Bool

    init(path: String, delimiter: String = "\n", encoding: String.Encoding = .utf8, bufferSize: Int = 4096) throws {
        guard let fileHandle = FileHandle(forReadingAtPath: path),
              let delimiter = delimiter.data(using: encoding) else {
            throw FileReaderError.failedToOpen
        }
        self.encoding = encoding
        self.delimiter = delimiter
        self.bufferSize = bufferSize
        self.fileHandle = fileHandle
        self.buffer = Data(capacity: bufferSize)
        self.atEOF = false
    }

    convenience init(resource: String, encoding: String.Encoding = .utf8) throws {
        guard let url = Bundle.module.url(forResource: resource, withExtension: "txt") else {
            throw FileReaderError.resourceNotFound
        }
        try self.init(path: url.path(percentEncoded: true))
    }

    deinit {
        fileHandle.closeFile()
    }

    func nextLine() -> String? {
        while !atEOF {
            if let line = buffer.range(of: delimiter) {
                defer { buffer.removeSubrange(0..<line.upperBound) }
                return String(data: buffer.subdata(in: 0..<line.lowerBound), encoding: encoding)
            }
            let tmpData = fileHandle.readData(ofLength: bufferSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                atEOF = true
                if buffer.count > 0 {
                    defer { buffer.count = 0 }
                    return String(data: buffer, encoding: encoding)
                }
            }
        }
        return nil
    }
}

extension FileReader: Sequence, LazySequenceProtocol {
    func makeIterator() -> AnyIterator<String> {
        AnyIterator { self.nextLine() }
    }
}

func readLines(from resource: String) throws -> AnyIterator<String> {
    try FileReader(resource: resource).makeIterator()
}

struct Measure {
    private(set) var start = ProcessInfo.processInfo.systemUptime

    var elapsed: Double { ProcessInfo.processInfo.systemUptime - start }

    mutating func reset() { start = ProcessInfo.processInfo.systemUptime }
}
