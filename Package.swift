// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ScreenSwapper",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "ScreenSwapper", targets: ["ScreenSwapper"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ScreenSwapper",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
