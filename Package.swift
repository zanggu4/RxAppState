// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "RxSwiftExt",
    platforms: [
        .iOS(.v8), .tvOS(.v9), .macOS(.v10_11)
    ],
    products: [
        .library(name: "RxAppState", targets: ["RxAppState"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        .target(name: "RxAppState",
                dependencies: ["RxSwift", "RxCocoa"],
                path: "RxAppState",
                sources: ["Pod/Classes"])
    ],
    swiftLanguageVersions: [.v4_2, .v5]
)
