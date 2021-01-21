// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "RxAppState",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "RxAppState",
            targets: ["RxAppState"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(
            name: "RxAppState",
            dependencies: [
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift")
            ],
            path: "Pod/Classes"
        )
    ],
    swiftLanguageVersions: [.v4_2, .v5]
)
