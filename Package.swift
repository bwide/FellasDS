// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FellasDS",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FellasDS",
            targets: ["FellasDS"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/bwide/FellasLocalization", from: "1.0.0"),
        .package(url: "https://github.com/bwide/FellasStoreKit", from: "1.2.0"),
        .package(path: "../../Packages/SwiftResources"),
        .package(path: "../../Packages/FellasAnalytics"),
        .package(name: "Shiny", url: "https://github.com/maustinstar/shiny", from: "0.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FellasDS",
            dependencies: ["FellasLocalization", "FellasStoreKit", "SwiftResources", "Shiny", "FellasAnalytics"],
            path: "Sources/FellasDS",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "FellasDSTests",
            dependencies: ["FellasDS"]),
    ]
)
