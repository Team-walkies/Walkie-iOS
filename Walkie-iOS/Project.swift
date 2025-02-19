import ProjectDescription

let project = Project(
    name: "Walkie-iOS",
    targets: [
        .target(
            name: "Walkie-iOS",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.startup.walkie",
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
            resources: [
                "Walkie-iOS/Resources/**",
                "Walkie-iOS/Resources/GoogleService-Info.plist"
            ],
            scripts: [
                .pre(
                    script: """
                       ROOT_DIR="$(pwd)"
                       "$ROOT_DIR/swiftlint" --config "$ROOT_DIR/.swiftlint.yml"
                       """,
                    name: "SwiftLint",
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: [
                .external(name: "Lottie"),
                .external(name: "FirebaseMessaging")
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"
                ]
            )
        ),
    ]
)
