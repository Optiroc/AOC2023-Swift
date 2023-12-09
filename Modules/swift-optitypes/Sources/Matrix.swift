//
//  Matrix.swift
//  OptiTypes
//
//  Created by David Lindecrantz on 2023-12-02
//

public struct Matrix<Element>: RandomAccessCollection {
    public typealias Index = MatrixIndex

    public let view: MatrixView

    @usableFromInline let storage: MatrixStorage<Element>

    @inlinable
    public var startIndex: MatrixIndex {
        MatrixIndex(.zero, view, storage.size)
    }

    @inlinable
    public var endIndex: MatrixIndex {
        MatrixIndex(MatrixOffset(0, view.size.rows), view, storage.size)
    }

    @inlinable
    public func index(_ offset: MatrixOffset) -> MatrixIndex {
        MatrixIndex(offset, view, storage.size)
    }

    @inlinable
    public func slice(_ view: MatrixView) -> Self {
        Matrix(view: self.view.sliced(by: view), storage: storage)
    }

    @inlinable
    public func offset(by offset: MatrixOffset) -> Self {
        Matrix(view: self.view.offset(by: offset), storage: storage)
    }

    @inlinable
    public func offset(edges: MatrixEdges) -> Self {
        Matrix(view: self.view.offset(edges: edges), storage: storage)
    }

    @inlinable
    public func slice(_ view: MatrixView, clamped: Bool) -> Self {
        guard clamped else { return Matrix(view: self.view.sliced(by: view), storage: storage) }
        return Matrix(view: self.view.sliced(by: view, clampedTo: storage.size), storage: storage)
    }

    @inlinable
    public func offset(by offset: MatrixOffset, clamped: Bool) -> Self {
        guard clamped else { return Matrix(view: self.view.offset(by: offset), storage: storage) }
        return Matrix(view: self.view.offset(by: offset, clampedTo: storage.size), storage: storage)
    }

    @inlinable
    public func offset(edges: MatrixEdges, clamped: Bool) -> Self {
        guard clamped else { return Matrix(view: self.view.offset(edges: edges), storage: storage) }
        return Matrix(view: self.view.offset(edges: edges, clampedTo: storage.size), storage: storage)
    }

    @inlinable
    public func column(_ index: Int) -> Self {
        Matrix(view: self.view.sliced(by: MatrixView(
            MatrixOffset(index, 0), MatrixSize(1, view.size.rows))
        ), storage: storage)
    }

    @inlinable
    public func row(_ index: Int) -> Self {
        Matrix(view: self.view.sliced(by: MatrixView(
            MatrixOffset(0, index), MatrixSize(view.size.columns, 1)
        )), storage: storage)
    }

    @inlinable
    public subscript(position: MatrixIndex) -> Element {
        storage.array[position.storageIndex]
    }

    public init(size: MatrixSize, repeating value: Element) {
        self.storage = MatrixStorage(size: size, repeating: value)
        self.view = MatrixView(.zero, size)
    }

    public init<S: Sequence>(size: MatrixSize, sequence: S) where S.Element == Element {
        self.storage = MatrixStorage(size: size, sequence: sequence)
        self.view = MatrixView(.zero, size)
    }

    @usableFromInline
    init(storage: MatrixStorage<Element>) {
        self.storage = storage
        self.view = MatrixView(.zero, storage.size)
    }

    @usableFromInline
    init(view: MatrixView, storage: MatrixStorage<Element>) {
        precondition(view.size.rows >= 0 && view.size.columns >= 0, "Initialized Matrix with dimension(s) < 0")
        precondition(view.offset.column >= 0 && view.offset.row >= 0, "Initialized Matrix with offset out of bounds")
        precondition(view.size.columns + view.offset.column <= storage.size.columns, "Initialized Matrix with size.columns out of bounds")
        precondition(view.size.rows + view.offset.row <= storage.size.rows, "Initialized Matrix with size.rows out of bounds")
        self.storage = storage
        self.view = view
    }
}

public struct MatrixView: Equatable, Hashable {
    public let offset: MatrixOffset
    public let size: MatrixSize

    @inlinable
    public static func == (lhs: MatrixView, rhs: MatrixView) -> Bool {
        (lhs.offset == rhs.offset) && (lhs.size == rhs.size)
    }

    @inlinable
    public init(_ offset: MatrixOffset, _ size: MatrixSize) {
        self.offset = offset
        self.size = size
    }

    @inlinable
    public func sliced(by slice: MatrixView) -> MatrixView {
        MatrixView(MatrixOffset(offset.column + slice.offset.column, offset.row + slice.offset.row), slice.size)
    }

    @inlinable
    public func offset(by offset: MatrixOffset) -> MatrixView {
        MatrixView(MatrixOffset(self.offset.column + offset.column, self.offset.row + offset.row), size)
    }

    @inlinable
    public func offset(edges: MatrixEdges) -> MatrixView {
        MatrixView(
            MatrixOffset(offset.column - edges.left, offset.row - edges.top),
            MatrixSize(size.columns + edges.right + edges.left, size.rows + edges.top + edges.bottom)
        )
    }

    @inlinable
    public func sliced(by slice: MatrixView, clampedTo clampSize: MatrixSize) -> MatrixView {
        return MatrixView(
            MatrixOffset(offset.column + slice.offset.column, offset.row + slice.offset.row), slice.size
        ).clamped(to: clampSize)
    }

    @inlinable
    public func offset(by offset: MatrixOffset, clampedTo clampSize: MatrixSize) -> MatrixView {
        return MatrixView(
            MatrixOffset(self.offset.column + offset.column, self.offset.row + offset.row), size
        ).clamped(to: clampSize)
    }

    @inlinable
    public func offset(edges: MatrixEdges, clampedTo clampSize: MatrixSize) -> MatrixView {
        return MatrixView(
            MatrixOffset(offset.column - edges.left, offset.row - edges.top),
            MatrixSize(size.columns + edges.right + edges.left, size.rows + edges.top + edges.bottom)
        ).clamped(to: clampSize)
    }

    @inlinable
    public func clamped(to clampSize: MatrixSize) -> MatrixView {
        let colStart = min(max(offset.column, 0), clampSize.columns)
        let colEnd = min(max(offset.column + size.columns, 0), clampSize.columns)
        let rowStart = min(max(offset.row, 0), clampSize.rows)
        let rowEnd = min(max(offset.row + size.rows, 0), clampSize.columns)
        return MatrixView(
            MatrixOffset(colStart, rowStart),
            MatrixSize(colEnd - colStart, rowEnd - rowStart)
        )
    }

    @inlinable
    public func overlaps(with other: MatrixView) -> Bool {
        max(offset.column, other.offset.column) <
            min(offset.column + size.columns, other.offset.column + other.size.columns) &&
        max(offset.row, other.offset.row) <
            min(offset.row + size.rows, other.offset.row + other.size.rows)
    }
}

public struct MatrixIndex: Comparable, Strideable {
    public typealias Stride = Int

    public let offset: MatrixOffset
    public let view: MatrixView
    @usableFromInline let storageSize: MatrixSize
    @usableFromInline let storageIndex: Int

    @inlinable
    public var flatOffset: Int {
        view.size.columns * offset.row + offset.column
    }

    @inlinable
    public static func < (lhs: MatrixIndex, rhs: MatrixIndex) -> Bool {
        lhs.storageIndex < rhs.storageIndex
    }

    @inlinable
    public func distance(to other: MatrixIndex) -> Int {
        precondition(self.view == other.view, "Comparing MatrixIndices with non-equal views")
        return other.flatOffset - self.flatOffset
    }

    @inlinable
    public func advanced(by n: Int) -> MatrixIndex {
        let cn = offset.column + n
        if cn >= 0, cn < view.size.columns {
            return MatrixIndex(MatrixOffset(cn, offset.row), view, storageSize)
        } else {
            let (r, c) = (offset.row * view.size.columns + cn).quotientAndRemainder(dividingBy: view.size.columns)
            return MatrixIndex(MatrixOffset(c, r), view, storageSize)
        }
    }

    @inlinable
    public init(_ offset: MatrixOffset, _ view: MatrixView, _ storageSize: MatrixSize) {
        self.offset = offset
        self.view = view
        self.storageSize = storageSize
        self.storageIndex = (view.offset.row + offset.row) * storageSize.columns + view.offset.column + offset.column
    }
}

public struct MatrixSize: Equatable, Hashable {
    public let columns: Int
    public let rows: Int

    @inlinable
    public static var zero: Self { .init(0, 0) }

    @inlinable
    public init(_ columns: Int, _ rows: Int) {
        self.columns = columns
        self.rows = rows
    }
}

public struct MatrixOffset: Equatable, Hashable {
    public let column: Int
    public let row: Int

    @inlinable
    public static var zero: Self { .init(0, 0) }

    @inlinable
    public init(_ column: Int, _ row: Int) {
        self.column = column
        self.row = row
    }
}

public struct MatrixEdges: Equatable, Hashable {
    public let top: Int
    public let right: Int
    public let bottom: Int
    public let left: Int

    @inlinable
    public static var zero: Self { .init(0, 0, 0, 0) }

    @inlinable
    public static var one: Self { .init(1, 1, 1, 1) }

    @inlinable
    public init(_ top: Int, _ right: Int, _ bottom: Int, _ left: Int) {
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
    }
}

public extension Matrix {
    var columns: some RandomAccessCollection<Matrix<Element>> {
        Matrix.Columns(self)
    }

    struct Columns: RandomAccessCollection {
        public typealias Element = Matrix<Matrix.Element>
        public typealias Index = Int

        @usableFromInline
        let matrix: Matrix<Matrix.Element>

        @inlinable
        public var startIndex: Int { 0 }

        @inlinable
        public var endIndex: Int { matrix.view.size.columns }

        @inlinable
        public subscript(position: Int) -> Matrix<Matrix.Element> {
            matrix.column(position)
        }

        @usableFromInline
        init(_ matrix: Matrix<Matrix.Element>) {
            self.matrix = matrix
        }
    }
}

public extension Matrix {
    var rows: some RandomAccessCollection<Matrix<Element>> {
        Matrix.Rows(self)
    }

    struct Rows: RandomAccessCollection {
        public typealias Element = Matrix<Matrix.Element>
        public typealias Index = Int

        @usableFromInline
        let matrix: Matrix<Matrix.Element>

        @inlinable
        public var startIndex: Int { 0 }

        @inlinable
        public var endIndex: Int { matrix.view.size.rows }

        @inlinable
        public subscript(position: Int) -> Matrix<Matrix.Element> {
            matrix.row(position)
        }

        @usableFromInline
        init(_ matrix: Matrix<Matrix.Element>) {
            self.matrix = matrix
        }
    }
}

public extension Matrix {
    func continuousMatricesSatisfying(_ predicate: (Element) -> Bool) -> [Matrix] {
        self.continuousViewsSatisfying(predicate).map {
            self.slice($0)
        }
    }

    func continuousViewsSatisfying(_ predicate: (Element) -> Bool) -> [MatrixView] {
        self.rows.enumerated().flatMap { rowIndex, row in
            row.enumerated()
                .map {
                    ($0.0, predicate($0.1))
                }.split {
                    $0.1 == false
                }.map {
                    MatrixView(.init($0[$0.startIndex].0, rowIndex), .init($0.count, 1))
                }
        }
    }
}

@usableFromInline
struct MatrixStorage<T> {
    @usableFromInline let size: MatrixSize
    @usableFromInline let count: Int
    @usableFromInline var array: ContiguousArray<T>

    init(size: MatrixSize, repeating: T) {
        self.size = size
        self.count = size.columns * size.rows
        self.array = ContiguousArray(repeating: repeating, count: size.columns * size.rows)
    }

    init<S: Sequence>(size: MatrixSize, sequence: S) where S.Element == T {
        self.size = size
        self.count = size.columns * size.rows
        array = ContiguousArray(sequence)
        precondition(array.count == count, "Initialized MatrixStorage<T> with dimensions not matching element count")
    }

    @inlinable
    subscript(column: Int, row: Int) -> T {
        get { array[size.columns * row + column] }
        set { array[size.columns * row + column] = newValue }
    }

    @inlinable
    func at(_ offset: MatrixOffset) -> T? {
        let index = size.columns * offset.row + offset.column
        return (index >= 0 && index < count) ? array[index] : nil
    }
}

public enum MatrixError: Error {
    case invalidSourceData
}

// - MARK: StringConvertible

extension Matrix: CustomStringConvertible {
    public var description: String {
        "[" + self.map { "\"\($0)\"" }.joined(separator: ", ") + "]"
    }
}

// - MARK: Matrix<Character> specializations

public extension Matrix<Character> {
    var string: String {
        String(self)
    }

    static func from(sequence: some Sequence<String>) throws -> Matrix {
        let lines = sequence.map { $0 }
        guard lines.count > 0 else { throw MatrixError.invalidSourceData }
        let columns = lines[0].count
        guard lines.allSatisfy({ $0.count == columns }) else { throw MatrixError.invalidSourceData }
        return Matrix<Character>(
            size: MatrixSize(columns, lines.count),
            sequence: lines.reduce(into: Array<Character>()) { $0 += $1 }
        )
    }
}
