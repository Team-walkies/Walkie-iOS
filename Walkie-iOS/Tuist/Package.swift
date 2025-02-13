// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [:]
    )
#endif

let package = Package(
    name: "Walkie-iOS",
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.1"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.17.1")
    ],
    targets: [
        .target(
            name: "Walkie-iOS",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
