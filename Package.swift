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
    dependencies: [
        .package(url: "https://github.com/shaps80/SwiftUIBackports", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "SwiftHelp",
            dependencies: ["SwiftUIBackports"]
        ),
    ]
)
