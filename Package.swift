// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProviderClient",
    platforms: [
        .macOS(.v10_12)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.5.0"),
        .package(url: "https://github.com/vapor/websocket-kit", from: "1.1.2"),
        .package(url: "git@github.com:igorleonovich/provider-sdk-swift.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ProviderClient",
            dependencies: ["WebSocket", "ProviderSDK", "SPMUtility"]),
        .testTarget(
            name: "ProviderClientTests",
            dependencies: ["ProviderClient"]),
    ]
)
