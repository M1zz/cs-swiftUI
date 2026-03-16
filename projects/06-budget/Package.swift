// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BudgetApp",
    platforms: [.iOS(.v17)],
    targets: [
        .executableTarget(
            name: "BudgetApp",
            path: "Sources",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
