// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VibeLink",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "VibeLink",
            targets: ["VibeLink"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.18.0")
    ],
    targets: [
        .target(
            name: "VibeLink",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
            ]
        )
    ]
)
