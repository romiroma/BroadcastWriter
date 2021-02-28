// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "BroadcastWriter",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "BroadcastWriter",
            targets: ["BroadcastWriter"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "BroadcastWriter",
            dependencies: []),
        .testTarget(
            name: "BroadcastWriterTests",
            dependencies: ["BroadcastWriter"]),
    ]
)
