// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HighlightSwiftSyntax",
    platforms: [
        .macOS(.v11),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "HighlightSwiftSyntax",
            targets: ["HighlightSwiftSyntax"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//        .package(url: "https://github.com/apple/swift-syntax.git", branch: "release/5.7"),
        .package(url: "https://github.com/apple/swift-syntax.git", exact: "0.50700.1"),
        .package(url: "https://github.com/pointfreeco/swift-prelude", branch: "main"),
        .package(url: "https://github.com/atacan/BinaryBirds-swift-html", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "HighlightSwiftSyntax",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                .product(name: "Prelude", package: "swift-prelude"),
                .product(name: "SwiftHtml", package: "BinaryBirds-swift-html"),
            ]),
        .testTarget(
            name: "HighlightSwiftSyntaxTests",
            dependencies: ["HighlightSwiftSyntax"]),
    ]
)
