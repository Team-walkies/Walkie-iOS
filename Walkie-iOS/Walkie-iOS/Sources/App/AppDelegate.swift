//
//  AppDelegate.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import UIKit
import KakaoSDKCommon

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print("[DEBUG][AppDelegate][didFinishLaunching] App launched with options: \(launchOptions?.description ?? "none")")
        
        // Kakao SDK 초기화
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        
        print("[DEBUG][AppDelegate][didFinishLaunching] App initialization completed")
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("[DEBUG][AppDelegate][willTerminate] App will terminate")
    }
}
