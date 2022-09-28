// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHelp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "SwiftHelp",
            targets: ["SwiftHelp"]
        ),
    ],
    targets: [
        .target(name: "SwiftHelp"),
    ]
)
