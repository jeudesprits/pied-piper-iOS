// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PiedPiperApplication",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(name: "PiedPiperApplication", targets: ["PiedPiperApplication"]),
    ],
    targets: [
        .target(name: "PiedPiperApplication"),
        .testTarget(name: "PiedPiperApplicationTests", dependencies: ["PiedPiperApplication"]),
    ]
)
