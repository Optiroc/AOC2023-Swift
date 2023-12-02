// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOC2023",
    platforms: [
        .macOS(.v14), .iOS(.v17)
    ],
    dependencies: [
        .package(name: "LineReader", path: "./Modules/LineReader"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.5"),
    ],
    targets: [
        .executableTarget(
            name: "AOC2023",
            dependencies: [
                .product(name: "LineReader", package: "LineReader"),
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
            ],
            path: "Sources",
            resources: [
                .process("Data"),
            ],
            swiftSettings: [
                .unsafeFlags(["-enable-bare-slash-regex"])
            ]
        )
    ]
)
