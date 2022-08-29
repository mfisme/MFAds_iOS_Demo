//
//  AppDelegate.swift
//  MFAdsDemo_Swift
//
//  Created by cc on 2022/5/30.
//

import UIKit
import MFAdsCore
#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        settingMFAdsSDK()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(requestTracking), userInfo: nil, repeats: false)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        requestTracking();
    }
    // 海外调试id: CClEu6baG0GPgn6i
    // 国内调试id：ty8hTrna2PfUkvOR
    /// 初始化sdk
    func settingMFAdsSDK() {
        MFAdSdkConfig.shareInstance().level = MFAdLogLevel.debug
        MFAdSdkConfig.shareInstance().setAppID("ty8hTrna2PfUkvOR") { success in
            if !success {
                print("初始化SDK成功")
            }
        }
    }
    // 授权广告弹窗
    @objc func requestTracking() {
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                
            })
        }
    }
}

