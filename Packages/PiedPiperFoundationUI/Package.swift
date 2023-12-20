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
]

if ProcessInfo.processInfo.environment["SWIFT_TRACK_TYPECHECKING_TIME"] != nil {
    swiftSettings += CollectionOfOne(.unsafeFlags([
        "-Xfrontend", "-warn-long-expression-type-checking=100",
        "-Xfrontend", "-warn-long-function-bodies=100",
    ], .when(configuration: .debug)))
}

let package = Package(
    name: "PiedPiperFoundationUI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "PiedPiperFoundationUI", targets: ["PiedPiperFoundationUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", branch: "main"),
        .package(path: "../SwiftUtilities"),
        .package(path: "../osUtilities"),
        .package(path: "../UIKitUtilities"),
    ],
    targets: [
        .target(name: "PiedPiperFoundationUI", dependencies: [
            .product(name: "OrderedCollections", package: "swift-collections"),
            "SwiftUtilities",
            "osUtilities",
            "UIKitUtilities",
        ]),
        .testTarget(name: "PiedPiperFoundationUITests", dependencies: ["PiedPiperFoundationUI"]),
    ]
)

for target in package.targets {
    target.swiftSettings = swiftSettings
}
