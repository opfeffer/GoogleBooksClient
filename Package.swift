// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "GoogleBooksClient",
    products: [
        .library(name: "GoogleBooksClient", targets: ["GoogleBooksClient"]),
        ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "10.0.0"))
    ],
    targets: [
        .target(name: "GoogleBooksClient", dependencies: ["Moya"], path: "Sources"),
        .testTarget(name: "GoogleBooksClientTests", dependencies: ["GoogleBooksClient"], path: "Tests"),
    ]
)
