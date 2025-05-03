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
                    "NSMotionUsageDescription": "사용자 건강 데이터를 기록하기 위한 권한을 허용합니다.",
                    "NSLocationWhenInUseUsageDescription": "내 주변 스팟을 탐색하기 위해 현재 위치를 확인합니다.",
                    "NSLocationAlwaysAndWhenInUseUsageDescription": "스팟을 탐색하기 위해 백그라운드 동작 시의 위치 정보 접근을 허가해 주세요.",
                    "NSLocationAlwaysUsageDescription": "스팟을 탐색하기 위해 백그라운드 동작 시의 위치 정보 접근을 허가해 주세요.",
                    "BASE_URL": "$(BASE_URL)",
                    "WEB_URL": "$(WEB_URL)",
                    "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
                    "NSSupportsLiveActivities": true,
                    "CFBundleURLTypes": [
                        [
                            "CFBundleTypeRole": "Editor",
                            "CFBundleURLSchemes": [
                                "kakao$(KAKAO_NATIVE_APP_KEY)"
                            ]
                        ]
                    ],
                    "LSApplicationQueriesSchemes": [
                        "kakaokompassauth"
                    ],
                    "UIAppFonts": [
                        "Pretendard-ExtraBold.ttf",
                        "Pretendard-Bold.ttf",
                        "Pretendard-Medium.ttf",
                    ],
                    "UIUserInterfaceStyle": "Light",
                    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true
                    ],
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [:]
                    ],
                    "BGTaskSchedulerPermittedIdentifiers": [
                        "com.walkie.ios.check.step",
                        "com.walkie.ios.update.step"
                    ],
                    "UIBackgroundModes": [
                        "fetch",
                        "processing"
                    ]
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
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser"),
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
