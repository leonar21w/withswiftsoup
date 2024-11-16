// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "MyProfessor",
    platforms: [
        .iOS(.v14) // Specify the minimum iOS version as needed
    ],
    products: [
        .library(
            name: "MyProfessor",
            targets: ["MyProfessor"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.0")
    ],
    targets: [
        .target(
            name: "MyProfessor",
            dependencies: ["SwiftSoup"],
            path: "Sources",
            resources: [.process("Assets.xcassets")] // If you have any resources
        ),
        .testTarget(
            name: "MyProfessorTests",
            dependencies: ["MyProfessor"]
        )
    ]
)

