// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "RecordmeCore",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "RecordmeCore", targets: ["RecordmeCore"]),
    ],
    targets: [
        .target(name: "RecordmeCore"),
        .testTarget(name: "RecordmeCoreTests", dependencies: ["RecordmeCore"]),
    ]
)
