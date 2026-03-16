// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TimerApp",
    platforms: [.iOS(.v17), .macOS(.v14)],
    targets: [
        .executableTarget(
            name: "TimerApp",
            path: "Sources"
        )
    ]
)
