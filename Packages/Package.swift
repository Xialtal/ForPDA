// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ForPDA",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Features
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "ArticlesListFeature", targets: ["ArticlesListFeature"]),
        .library(name: "ArticleFeature", targets: ["ArticleFeature"]),
        .library(name: "BookmarksFeature", targets: ["BookmarksFeature"]),
        .library(name: "ForumFeature", targets: ["ForumFeature"]),
        .library(name: "MenuFeature", targets: ["MenuFeature"]),
        .library(name: "AuthFeature", targets: ["AuthFeature"]),
        .library(name: "ProfileFeature", targets: ["ProfileFeature"]),
        .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
        
        // Clients
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "CacheClient", targets: ["CacheClient"]),
        .library(name: "ParsingClient", targets: ["ParsingClient"]),
        .library(name: "AnalyticsClient", targets: ["AnalyticsClient"]),
        .library(name: "PasteboardClient", targets: ["PasteboardClient"]),
        .library(name: "NotificationsClient", targets: ["NotificationsClient"]),
        .library(name: "HapticClient", targets: ["HapticClient"]),
        .library(name: "PersistenceKeys", targets: ["PersistenceKeys"]),
        
        // Shared
        .library(name: "Models", targets: ["Models"]),
        .library(name: "SharedUI", targets: ["SharedUI"]),
        .library(name: "TCAExtensions", targets: ["TCAExtensions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SubvertDev/PDAPI_SPM.git", from: "0.1.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.15.2"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", from: "5.3.0"),
        .package(url: "https://github.com/hyperoslo/Cache.git", from: "7.3.0"),
        .package(url: "https://github.com/kean/Nuke.git", from: "12.8.0"),
        .package(url: "https://github.com/mixpanel/mixpanel-swift.git", from: "4.3.0"),
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.39.0"),
        .package(url: "https://github.com/CSolanaM/SkeletonUI.git", from: "2.0.2"),
        .package(url: "https://github.com/raymondjavaxx/SmoothGradient.git", branch: "main"),
        .package(url: "https://github.com/SvenTiigi/YouTubePlayerKit.git", from: "1.9.0"),
        .package(url: "https://github.com/SubvertDev/AlertToast.git", revision: "d0f7d6b"),
        .package(url: "https://github.com/kirualex/SwiftyGif.git", from: "5.4.4"),
        .package(url: "https://github.com/ZhgChgLi/ZMarkupParser.git", from: "1.11.0"),
        .package(url: "https://github.com/SubvertDev/RichTextKit.git", branch: "main")
    ],
    targets: [
        
        // MARK: - Features
        
        .target(
            name: "AppFeature",
            dependencies: [
                "ArticlesListFeature",
                "ArticleFeature",
                "BookmarksFeature",
                "ForumFeature",
                "MenuFeature",
                "AuthFeature",
                "ProfileFeature",
                "SettingsFeature",
                "AnalyticsClient",
                "CacheClient",
                "NotificationsClient",
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "AlertToast", package: "AlertToast")
            ]
        ),
        .target(
            name: "ArticlesListFeature",
            dependencies: [
                "Models",
                "SharedUI",
                "APIClient",
                "AnalyticsClient",
                "PasteboardClient",
                "HapticClient",
                "TCAExtensions",
                "PersistenceKeys",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "NukeUI", package: "nuke"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        .target(
            name: "ArticleFeature",
            dependencies: [
                "Models",
                "SharedUI",
                "APIClient",
                "CacheClient",
                "AnalyticsClient",
                "ParsingClient",
                "PasteboardClient",
                "HapticClient",
                "TCAExtensions",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SkeletonUI", package: "SkeletonUI"),
                .product(name: "NukeUI", package: "nuke"),
                .product(name: "YouTubePlayerKit", package: "YouTubePlayerKit"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
                .product(name: "SmoothGradient", package: "SmoothGradient")
            ]
        ),
        .target(
            name: "BookmarksFeature",
            dependencies: [
                "Models",
                "SharedUI",
                "APIClient",
                "CacheClient",
                "PasteboardClient",
                "AnalyticsClient",
                "PersistenceKeys",
                "TCAExtensions",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SkeletonUI", package: "SkeletonUI"),
                .product(name: "NukeUI", package: "nuke"),
            ]
        ),
        .target(
            name: "ForumFeature",
            dependencies: [
                "Models",
                "SharedUI",
                "APIClient",
                "CacheClient",
                "AnalyticsClient",
                "ParsingClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "NukeUI", package: "nuke")
            ]
        ),
        .target(
            name: "MenuFeature",
            dependencies: [
                "APIClient",
                "PersistenceKeys",
                "AnalyticsClient",
                "CacheClient",
                "SharedUI",
                "TCAExtensions",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SkeletonUI", package: "SkeletonUI"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        .target(
            name: "AuthFeature",
            dependencies: [
                "APIClient",
                "AnalyticsClient",
                "HapticClient",
                "PersistenceKeys",
                "TCAExtensions",
                "SharedUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "NukeUI", package: "nuke"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        .target(
            name: "ProfileFeature",
            dependencies: [
                "Models",
                "SharedUI",
                "APIClient",
                "AnalyticsClient",
                "PersistenceKeys",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "RichTextKit", package: "RichTextKit"),
                .product(name: "SkeletonUI", package: "SkeletonUI"),
                .product(name: "NukeUI", package: "nuke"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "AnalyticsClient",
                "PasteboardClient",
                "CacheClient",
                "TCAExtensions",
                "Models",
                "SharedUI",
                "PersistenceKeys",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        
        // MARK: - Clients
        
            .target(
                name: "APIClient",
                dependencies: [
                    "ParsingClient",
                    "CacheClient",
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                    .product(name: "PDAPI_SPM", package: "PDAPI_SPM")
                ]
            ),
        .target(
            name: "PersistenceKeys",
            dependencies: [
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "AnalyticsClient",
            dependencies: [
                "Models",
                "PersistenceKeys",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Mixpanel", package: "mixpanel-swift"),
                .product(name: "Sentry", package: "sentry-cocoa")
            ]
        ),
        .target(
            name: "ParsingClient",
            dependencies: [
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "ZMarkupParser", package: "ZMarkupParser")
            ]
        ),
        .target(
            name: "PasteboardClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "NotificationsClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "HapticClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "CacheClient",
            dependencies: [
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Cache", package: "Cache"),
                .product(name: "Nuke", package: "nuke")
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
                .product(name: "NukeUI", package: "nuke"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
                .product(name: "SwiftyGif", package: "SwiftyGif"),
                .product(name: "SkeletonUI", package: "SkeletonUI")
            ]
        ),
        .target(
            name: "TCAExtensions",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
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

for target in package.targets where target.type != .binary {
    var swiftSettings = target.swiftSettings ?? []
    
    #if !hasFeature(ExistentialAny)
    swiftSettings.append(.enableUpcomingFeature("ExistentialAny"))
    swiftSettings.append(
        .unsafeFlags(["-Xfrontend",
                      "-warn-long-function-bodies=500",
                      "-Xfrontend",
                      "-warn-long-expression-type-checking=100"])
    )
    #endif
    
    target.swiftSettings = swiftSettings
}
