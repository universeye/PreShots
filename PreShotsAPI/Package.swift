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
        .library(
            name: "ImagesSetsFeature",
            targets: ["ImagesSetsFeature"]),
        .library(
            name: "DestinationManager",
            targets: ["DestinationManager"]),
    ],
//    dependencies: [
//        .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "5.2.2")
//    ],
    targets: [
        .target(
            name: "PreShotsAPI"),
        .target(
            name: "ImportImagesFeature",
            dependencies: ["Models"]),
        .target(
            name: "Models"),
        .target(
            name: "ImageResizeFeature",
            dependencies: ["Models", "DestinationManager", "ImportImagesFeature"/*, .product(name: "RevenueCat", package: "purchases-ios")*/]),
        .target(
            name: "ImagesSetsFeature",
            dependencies: ["DestinationManager", "Models"]),
        .target(
            name: "DestinationManager"),
        .testTarget(
            name: "PreShotsAPITests",
            dependencies: ["ImageResizeFeature", "Models"]),
    ]
)
