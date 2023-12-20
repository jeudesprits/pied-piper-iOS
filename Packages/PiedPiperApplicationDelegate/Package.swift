// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PiedPiperApplicationDelegate",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(name: "PiedPiperApplicationDelegate", targets: ["PiedPiperApplicationDelegate"]),
    ],
    dependencies: [
        .package(path: "../PiedPiperApplication"),
        .package(path: "../PiedPiperApplicationUI"),
    ],
    targets: [
        .target(name: "PiedPiperApplicationDelegate", dependencies: [
            "PiedPiperApplication",
            "PiedPiperApplicationUI",
        ]),
        .testTarget(name: "PiedPiperApplicationDelegateTests", dependencies: ["PiedPiperApplicationDelegate"]),
    ]
)
