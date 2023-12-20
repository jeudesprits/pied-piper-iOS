// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let lexborExclude: [String] = [
    "lexbor/source/lexbor/core/config.cmake",
    "lexbor/source/lexbor/css/config.cmake",
    "lexbor/source/lexbor/dom/config.cmake",
    "lexbor/source/lexbor/encoding/config.cmake",
    "lexbor/source/lexbor/html/config.cmake",
    "lexbor/source/lexbor/ns/config.cmake",
    "lexbor/source/lexbor/ports/posix/config.cmake",
    "lexbor/source/lexbor/ports/windows_nt",
    "lexbor/source/lexbor/punycode/config.cmake",
    "lexbor/source/lexbor/selectors/config.cmake",
    "lexbor/source/lexbor/tag/config.cmake",
    "lexbor/source/lexbor/unicode/config.cmake",
    "lexbor/source/lexbor/url/config.cmake",
    "lexbor/source/lexbor/utils/config.cmake",
]

let package = Package(
    name: "Lexbor",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(name: "Lexbor", targets: ["Lexbor"]),
    ],
    targets: [
        .target(name: "Lexbor", dependencies: ["CLexbor"]),
        .target(
            name: "CLexbor",
            exclude: lexborExclude,
            sources: ["lexbor/source"],
            publicHeadersPath: "lexbor/source"
        ),
        .testTarget(name: "LexborTests", dependencies: ["Lexbor"]),
    ],
    cLanguageStandard: .gnu17
)
