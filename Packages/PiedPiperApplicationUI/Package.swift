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
    name: "PiedPiperApplicationUI",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(name: "PiedPiperApplicationUI", targets: ["PiedPiperApplicationUI"]),
    ],
    dependencies: [
        .package(path: "../PiedPiperFoundationUI"),
        .package(path: "../PiedPiperMainUI"),
    ],
    targets: [
        .target(name: "PiedPiperApplicationUI", dependencies: [
            "PiedPiperFoundationUI",
            "PiedPiperMainUI"
        ]),
        .testTarget(name: "PiedPiperApplicationUITests", dependencies: ["PiedPiperApplicationUI"]),
    ]
)

for target in package.targets {
    target.swiftSettings = swiftSettings
}
