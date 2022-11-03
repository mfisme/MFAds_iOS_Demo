//
//  AppDelegate.m
//  MFAdsDemo_OC
//
//  Created by cc on 2022/5/30.
//

#import "AppDelegate.h"
#import "AppDelegate+IDFA.h"
#import "AppDelegate+StartPage.h"
#import <MFAdsCore/MFAdSdkConfig.h> // MF 广告
#import "MFNavigationController.h"
#import "ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [self settingMFAds];
    
    ViewController *rootVC = [[ViewController alloc]init];
    MFNavigationController *nav = [[MFNavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    [self addStartPage];

    return YES;
}

/// 配置sdk
- (void)settingMFAds {
    
    [MFAdSdkConfig shareInstance].level = MFAdLogLevel_Debug;
    // 海外调试id: CClEu6baG0GPgn6i
    // 国内调试id: ty8hTrna2PfUkvOR
    [[MFAdSdkConfig shareInstance]registerAppID:@"ty8hTrna2PfUkvOR" withConfig:nil];
    
    
//    [[MFAdSdkConfig shareInstance]setAppID:@"CClEu6baG0GPgn6i" callBack:^(BOOL isSuccessful) {
//        if (!isSuccessful) {
//            NSLog(@"sdk initialized failed");
//        }
//    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /// 广告授权
    [self requestIDFA];
}
@end
