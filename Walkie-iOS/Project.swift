import ProjectDescription

let project = Project(
    name: "Walkie-iOS",
    targets: [
        .target(
            name: "Walkie-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.Walkie-iOS",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Walkie-iOS/Sources/**"],
            resources: ["Walkie-iOS/Resources/**"],
            dependencies: []
        ),
    ]
)
