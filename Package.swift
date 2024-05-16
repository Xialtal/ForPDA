// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ForPDA",
    platforms: [.iOS(.v16)],
    products: [
        // Features
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "NewsListFeature", targets: ["NewsListFeature"]),
        .library(name: "NewsFeature", targets: ["NewsFeature"]),
        .library(name: "MenuFeature", targets: ["MenuFeature"]),
        .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
        
        // Clients
        .library(name: "NewsClient", targets: ["NewsClient"]),
        .library(name: "SettingsClient", targets: ["SettingsClient"]),
        .library(name: "ParsingClient", targets: ["ParsingClient"]),
        
        // Shared
        .library(name: "Models", targets: ["Models"]),
        .library(name: "SharedUI", targets: ["SharedUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.10.3"),
        .package(url: "https://github.com/hmlongco/Factory", from: "2.3.2"),
        .package(url: "https://github.com/scinfu/SwiftSoup", from: "2.7.2"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols", from: "5.2.0"),
        .package(url: "https://github.com/kean/Nuke", from: "12.6.0"),
        .package(url: "https://github.com/mixpanel/mixpanel-swift", from: "4.2.7"),
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.25.2"),
        .package(url: "https://github.com/SvenTiigi/YouTubePlayerKit", from: "1.8.0"),
        .package(url: "https://github.com/mac-cain13/R.swift.git", from: "7.5.0")
    ],
    targets: [
        
        // MARK: - Features
        
        .target(
            name: "AppFeature",
            dependencies: [
                "NewsListFeature",
                "NewsFeature",
                "MenuFeature",
                "SettingsFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Mixpanel", package: "mixpanel-swift"),
                .product(name: "Sentry-Dynamic", package: "sentry-cocoa")
            ]
        ),
        .target(
            name: "NewsListFeature",
            dependencies: [
                "Models",
                "NewsClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "NukeUI", package: "nuke")
            ]
        ),
        .target(
            name: "NewsFeature",
            dependencies: [
                "Models",
                "NewsClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "NukeUI", package: "nuke"),
                .product(name: "YouTubePlayerKit", package: "YouTubePlayerKit")
            ]
        ),
        .target(
            name: "MenuFeature",
            dependencies: [
                "SharedUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        
        // MARK: - Clients
        
        .target(
            name: "NewsClient",
            dependencies: [
                "SettingsClient",
                "ParsingClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Factory", package: "Factory")
            ]
        ),
        .target(
            name: "SettingsClient",
            dependencies: [
                "Models"
            ]
        ),
        .target(
            name: "ParsingClient",
            dependencies: [
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SwiftSoup", package: "SwiftSoup")
            ]
        ),
        
        // MARK: - Shared
        
        .target(
            name: "Models",
            dependencies: [
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        .target(
            name: "SharedUI",
            dependencies: [
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift")]
        ),
        
        // MARK: - Tests
        
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                "AppFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
