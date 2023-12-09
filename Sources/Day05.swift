import Algorithms
import FileUtils

enum Day05 {
    typealias Mapping = (src: Int, dst: Int, len: Int)

    static func parse(_ input: some Sequence<String>) -> (seeds: [Int], mappings: [[Mapping]]) {
        var iter = input.makeIterator()
        let seeds = iter.next()!.split(separator: " ").compactMap { Int($0) }

        var mappings = [[Mapping]]()
        while let str = iter.next() {
            if str.contains("map:") {
                mappings.append([Mapping]())
            } else {
                let mv = str.split(separator: " ").compactMap { Int($0) }
                if mv.count == 3 {
                    mappings[mappings.indices.last!].append(Mapping(mv[1], mv[0], mv[2]))
                }
            }
        }
        mappings = mappings.map {
            $0.sorted(by: { $0.dst < $1.dst })
        }
        return (seeds, mappings)
    }

    static func seedToLocation(_ seed: Int, _ mappings: [[Mapping]]) -> Int {
        var v = seed
        for mapping in mappings {
            for m in mapping {
                if v >= m.src, v < m.src + m.len {
                    v += m.dst - m.src; break
                }
            }
        }
        return v
    }

    static func locationToSeed(_ location: Int, _ mappings: [[Mapping]]) -> Int {
        var v = location
        for mapping in mappings.reversed() {
            for m in mapping {
                if v >= m.dst, v < m.dst + m.len {
                    v -= m.dst - m.src; break
                }
            }
        }
        return v
    }

    static func lowestMappingSeeds(_ input: (seeds: [Int], mappings: [[Mapping]])) -> Int {
        input.seeds.map {
            seedToLocation($0, input.mappings)
        }.min()!
    }

    static func lowestMappingRanges(_ input: (seeds: [Int], mappings: [[Mapping]])) -> Int {
        let ranges = input.seeds.chunks(ofCount: 2).map {
            $0.first!...($0.first! + $0.last!)
        }
        var location = 0
        while true {
            location += 1
            let seed = locationToSeed(location, input.mappings)
            for range in ranges {
                if range.contains(seed) { return location }
            }
        }
    }

    static func part1() throws {
        let sampleValue = lowestMappingSeeds(parse(try LineReader("day05_sample.txt", bundle: .module)))
        print("05.1a Lowest location value in sample:", sampleValue)

        let puzzleValue = lowestMappingSeeds(parse(try LineReader("day05_input.txt", bundle: .module)))
        print("05.1b Lowest location value in puzzle:", puzzleValue)

        assert(35 == sampleValue)
        assert(88151870 == puzzleValue)
    }

    static func part2() throws {
        let sampleValue = lowestMappingRanges(parse(try LineReader("day05_sample.txt", bundle: .module)))
        print("05.2a Lowest location value in sample:", sampleValue)

        let puzzleValue = lowestMappingRanges(parse(try LineReader("day05_input.txt", bundle: .module)))
        print("05.2b Lowest location value in puzzle:", puzzleValue)

        assert(46 == sampleValue)
        assert(2008785 == puzzleValue)
    }
}
