//
//  MatrixTests.swift
//  OptiTypesTests
//
//  Created by David Lindecrantz on 2023-12-02
//

import XCTest
@testable import OptiTypes

private struct Measure {
    private(set) var start = ProcessInfo.processInfo.systemUptime

    var elapsed: Double { ProcessInfo.processInfo.systemUptime - start }

    mutating func reset() { start = ProcessInfo.processInfo.systemUptime }
}

final class MatrixTests: XCTestCase {
    static let input: [String] = [
        "467..114..",
        "...*......",
        "..35..6330",
        "0.....#...",
        "617*......",
        ".....+.58.",
        "..592.....",
        "......755.",
        "...$.*....",
        ".664.598..",
    ]

    func testIndex() throws {
        let m = try Matrix<Character>.from(sequence: Self.input)
        XCTAssertEqual(m[m.index(MatrixOffset(0, 0))], "4")
        XCTAssertEqual(m[m.index(MatrixOffset(1, 0))], "6")
        XCTAssertEqual(m[m.index(MatrixOffset(2, 2))], "3")
        XCTAssertEqual(m[m.index(MatrixOffset(3, 2))], "5")
    }

    func testIndexAdvancedBy() throws {
        let m = try Matrix<Character>.from(sequence: Self.input)
        let i0 = m.index(MatrixOffset(8, 2))
        let i1 = i0.advanced(by: 1)
        let i2 = i1.advanced(by: 1)
        let i3 = i2.advanced(by: 1)
        XCTAssertEqual(m[i0], "3")
        XCTAssertEqual(m[i1], "0")
        XCTAssertEqual(m[i2], "0")
        XCTAssertEqual(m[i3], ".")
    }

    func testMap() throws {
        let m = try Matrix<Character>.from(sequence: Self.input)
        XCTAssertEqual(m.map { $0 }, Self.input.flatMap { $0 })
    }

    func testSlice() throws {
        let m = try Matrix<Character>.from(sequence: Self.input)
        let s = m.slice(MatrixView(.init(2, 0), .init(2, 2)))
        XCTAssertEqual(s[s.index(.init(0, 0))], "7")
        XCTAssertEqual(s[s.index(.init(1, 0))], ".")
        XCTAssertEqual(s[s.index(.init(0, 1))], ".")
        XCTAssertEqual(s[s.index(.init(1, 1))], "*")
    }

    func testSliceAdvancedBy() throws {
        let m = try Matrix<Character>.from(sequence: Self.input)
        let s = m.slice(MatrixView(.init(2, 0), .init(2, 2)))

        let i0 = s.index(.init(0, 0))
        XCTAssertEqual(m[i0], "7")
        let i1 = i0.advanced(by: 1)
        XCTAssertEqual(m[i1], ".")
        let i2 = i1.advanced(by: 1)
        XCTAssertEqual(m[i2], ".")
        let i3 = i2.advanced(by: 1)
        XCTAssertEqual(m[i3], "*")
    }

    func testSliceMap() throws {
        let m = try Matrix<Character>.from(sequence: Self.input)
        let s = m.slice(MatrixView(.init(2, 0), .init(2, 2)))
        XCTAssertEqual(s.map { $0 }, ["7", ".", ".", "*"])
    }

    func testColumns() throws {
        let m = try Matrix<Character>.from(sequence: Self.input)

        m.columns.forEach {
            print($0.map { $0 })
        }
    }

    func testContinuousViewsSatisfying() throws {
        let m = try Matrix<Character>.from(sequence: Self.input)

        let t1 = m.row(8).continuousViewsSatisfying { $0 == "." }
        let e1: [MatrixView] = [
            .init(.init(0, 0), .init(3, 1)),
            .init(.init(4, 0), .init(1, 1)),
            .init(.init(6, 0), .init(4, 1))
        ]
        XCTAssertEqual(e1, t1)

        let t2 = m.slice(.init(.init(1, 1), .init(4, 3))).continuousViewsSatisfying { $0 == "." }
        let e2: [MatrixView] = [
            .init(.init(0, 0), .init(2, 1)),
            .init(.init(3, 0), .init(1, 1)),
            .init(.init(0, 1), .init(1, 1)),
            .init(.init(3, 1), .init(1, 1)),
            .init(.init(0, 2), .init(4, 1))
        ]
        XCTAssertEqual(e2, t2)
    }

    /*
    print("--------- row ->")
    let row0 = m.row(0)
    print(row0.map { $0 })

    print("--------- rows ->")
    for row in m.rows {
        print(row.map { $0 })
    }

    print("--------- column ->")
    let col0 = m.column(0)
    print(col0.map { $0 })

    print("--------- columns ->")
    for column in m.columns {
        print(column.map { $0 })
    }

    print("--------- offset ->")
    let mo1 = m.slice(MatrixView(.init(2, 2), .init(3, 3)))
    let mo2 = mo1.offset(by: .init(1, 1))
    let mo3 = mo2.offset(by: .init(-1, -1))
    print(mo1.rows.map { $0 })
    print(mo2.rows.map { $0 })
    print(mo3.rows.map { $0 })

    print("--------- offset edge ->")
    let me1 = m.slice(MatrixView(.init(2, 2), .init(3, 3)))
    let me2 = me1.offset(edges: .one)
    print(me1.rows.map { $0 })
    print(me2.rows.map { $0 })

    print("--------- clamping ->")
    let mc1 = m.slice(MatrixView(.init(-2, -1), .init(4, 3)), clamped: true)
    let mc2 = m.slice(MatrixView(.init(8, 9), .init(3, 3)), clamped: true)
    print(mc1.rows.map { $0 })
    print(mc2.rows.map { $0 })
    */
}
