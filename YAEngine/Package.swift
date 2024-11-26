// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "YAEngine",
    platforms: [
        .macOS(.v11), .iOS(.v14), .tvOS(.v14)
    ],
    products: [
        .library(name: "YAEngine", targets: ["YAEngine"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "YAEngine",
            path: "Sources")
    ],
    swiftLanguageVersions: [.v5]
)
