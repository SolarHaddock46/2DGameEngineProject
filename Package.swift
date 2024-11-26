// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Engine",
    platforms: [
        .macOS(.v11), .iOS(.v14), .tvOS(.v14)
    ],
    products: [
        .library(name: "Engine", targets: ["Engine"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Engine",
            path: "Sources")
    ],
    swiftLanguageVersions: [.v5]
)
