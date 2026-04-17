// swift-tools-version:6.0.0
import PackageDescription

let package = Package(
    name: "Capture",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Capture", targets: ["Capture"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Capture"),
        .target(name: "CaptureMocks", dependencies: ["Capture"]),
        .testTarget(name: "CaptureTests", dependencies: ["Capture", "CaptureMocks"], path: "Tests/Capture"),
    ]
)
