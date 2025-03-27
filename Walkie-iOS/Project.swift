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
                    "NSMotionUsageDescription": "걸음수 데이터 측정을 위해 데이터 접근 권한이 필요합니다.",
                    "BASE_URL": "$(BASE_URL)",
                    "NSSupportsLiveActivities": true,
                    "UIAppFonts": [
                        "Pretendard-ExtraBold.ttf",
                        "Pretendard-Bold.ttf",
                        "Pretendard-Medium.ttf",
                    ],
                    "UIUserInterfaceStyle": "Light",
                    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
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
                .external(name: "Moya"),
                .external(name: "CombineMoya"),
                .target(name: "WalkieWidget"),
                .target(name: "WalkieCommon")
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "MARKETING_VERSION": "1.0.0"
                ],
                configurations: [
                    .debug(name: "Debug", xcconfig: "Config/WalkieConfig.xcconfig"),
                    .release(name: "Release", xcconfig: "Config/WalkieConfig.xcconfig")
                ]
            )
        ),
        .target(
            name: "WalkieWidget",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.walkie.ios.walkiewidget",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension"
                ],
                "NSSupportsLiveActivities": true,
                "UIAppFonts": [
                    "Pretendard-ExtraBold.ttf",
                    "Pretendard-Bold.ttf",
                    "Pretendard-Medium.ttf",
                ]
            ]),
            sources: "WalkieWidget/Sources/**",
            resources: "WalkieWidget/Resources/**",
            dependencies: [
                .target(name: "WalkieCommon")
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "TARGETED_DEVICE_FAMILY": "1"
                ],
                configurations: []
            )
        ),
        .target(
            name: "WalkieCommon",
            destinations: .iOS,
            product: .framework,
            productName: "WalkieCommon",
            bundleId: "com.walkie.ios.common",
            infoPlist: .extendingDefault(
                with: [
                    "UIAppFonts": [
                        "Pretendard-ExtraBold.ttf",
                        "Pretendard-Bold.ttf",
                        "Pretendard-Medium.ttf",
                    ]
                ]
            ),
            sources: "WalkieCommon/Sources/**",
            resources: "WalkieCommon/Resources/**"
        ),
    ]
)
