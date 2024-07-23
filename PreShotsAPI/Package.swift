// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PreShotsAPI",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PreShotsAPI",
            targets: ["PreShotsAPI"]),
        .library(
            name: "ImportImagesFeature",
            targets: ["ImportImagesFeature"]),
        .library(
            name: "Models",
            targets: ["Models"]),
        .library(
            name: "ImageResizeFeature",
            targets: ["ImageResizeFeature"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PreShotsAPI"),
        .target(
            name: "ImportImagesFeature",
            dependencies: ["Models"]),
        .target(
            name: "Models"),
        .target(
            name: "ImageResizeFeature",
            dependencies: ["Models", "ImportImagesFeature"]),
        .testTarget(
            name: "PreShotsAPITests",
            dependencies: ["ImageResizeFeature", "Models"]),
    ]
)
