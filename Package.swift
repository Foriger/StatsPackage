// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "StatsPackage",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/Foriger/RadoSmallServer", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "StatsPackage",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "RadoSmallServer", package: "RadoSmallServer"),
            ]
        ),
    ]
)
