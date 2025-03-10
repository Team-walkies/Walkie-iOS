import ProjectDescription

let project = Project(
    name: "Walkie-iOS",
    targets: [
        .target(
            name: "Walkie-iOS",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.walkie.ios",
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "Walkie",
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIAppFonts": [
                        "Pretendard-ExtraBold.ttf",
                        "Pretendard-Bold.ttf",
                        "Pretendard-Medium.ttf",
                    ],
                    "NSMotionUsageDescription": "걸음수 데이터 측정을 위해 데이터 접근 권한이 필요합니다."
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
                .external(name: "FirebaseMessaging"),
                .external(name: "Moya")
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "MARKETING_VERSION": "1.0.0"
                ]
            )
        ),
    ]
)
