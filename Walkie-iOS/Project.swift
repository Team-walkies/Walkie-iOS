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
                    "UIAppFonts": [
                        "Pretendard-ExtraBold.ttf",
                        "Pretendard-Bold.ttf",
                        "Pretendard-Medium.ttf",
                    ],
                ]
            ),
            sources: ["Walkie-iOS/Sources/**"],
            resources: ["Walkie-iOS/Resources/**"],
            dependencies: []
        ),
    ]
)
