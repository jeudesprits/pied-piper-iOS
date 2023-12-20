// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

var swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    .enableUpcomingFeature("ImportObjcForwardDeclarations"),
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("IsolatedDefaultValues"),
    .enableUpcomingFeature("FullTypedThrows"),
]

if ProcessInfo.processInfo.environment["SWIFT_TRACK_TYPECHECKING_TIME"] != nil {
    swiftSettings += CollectionOfOne(.unsafeFlags([
        "-Xfrontend", "-warn-long-expression-type-checking=100",
        "-Xfrontend", "-warn-long-function-bodies=100",
    ], .when(configuration: .debug)))
}

let package = Package(
    name: "PiedPiperHomeUI",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(name: "PiedPiperHomeUI", targets: ["PiedPiperHomeUI"]),
    ],
    dependencies: [
        .package(path: "../SwiftUtilities"),
        .package(url: "https://github.com/apple/swift-algorithms.git", branch: "main"),
        .package(path: "../UIKitUtilities"),
        .package(path: "../PiedPiperFoundationUI"),
        .package(path: "../PiedPiperCoreUI"),
    ],
    targets: [
        .target(name: "PiedPiperHomeUI", dependencies: [
            "SwiftUtilities",
            .product(name: "Algorithms", package: "swift-algorithms"),
            "UIKitUtilities",
            "PiedPiperFoundationUI",
            "PiedPiperCoreUI",
        ]),
        .testTarget(name: "PiedPiperHomeUITests", dependencies: ["PiedPiperHomeUI"]),
    ]
)

for target in package.targets {
    target.swiftSettings = swiftSettings
}
