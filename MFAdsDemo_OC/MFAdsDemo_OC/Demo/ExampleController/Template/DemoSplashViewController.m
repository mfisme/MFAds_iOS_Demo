//
//  DemoSplashViewController.m
//  AAA
//
//  Created by CherryKing on 2019/11/1.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "DemoSplashViewController.h"
#import <MFAdsAdspot/MFAdSplash.h>

@interface DemoSplashViewController () <MFAdSplashDelegate>
@property(strong,nonatomic) MFAdSplash *adSplash;
@end

@implementation DemoSplashViewController

- (void)dealloc {
    NSLog(@"DemoSplashViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开屏广告";
}

- (void)loadAndShowAd {
    [super loadAndShowAd];
    [self loadAndShowSplashAd];
}

- (void)loadAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    [self.adSplash loadAd];
    [self loadAdWithState:AdState_Loading];
}

- (void)showAd {
    if (!_adSplash) {
        [DemoUtils showToast:@"请先加载广告"];
        return;
    }
    [self.adSplash showAd];
}

- (void)loadAndShowSplashAd{
    // 广告实例不要用初始化加载, 要确保每次都用最新的实例, 且一次广告流程中 delegate 不能发生变化
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    [self.adSplash loadAndShowAd];
    [self loadAdWithState:AdState_Loading];
}

- (void)deallocAd {
    if (!_adSplash) {
        return;
    }
    _adSplash.delegate = nil;
    _adSplash = nil;
}
#pragma mark - MFAdSplashDelegate

/// 内部渠道开始加载时调用
- (void)ad_SupplierWillLoad:(NSString *)supplierId {
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 内部渠道开始加载时调用", __func__]];
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);
}

- (void)ad_SuccessSortTag:(NSString *)sortTag {
    NSLog(@"选中了 rule '%@' %s", sortTag,__func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 选中了 rule '%@' ", __func__, sortTag]];
}

/// 广告数据拉取成功
- (void)ad_loadSuccess {
    NSLog(@"广告数据拉取成功 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告拉取成功", __func__]];
    [self loadAdWithState:AdState_LoadSucceed];
}

/// 广告数据拉取失败
- (void)ad_loadFailure:(NSError *)error {
    NSLog(@"广告数据拉取失败 %s - %@",__func__,error);
    [self loadAdWithState:AdState_LoadFailed];
    [self deallocAd];
}
/// 广告曝光成功
- (void)ad_exposured {
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告曝光成功", __func__]];
    NSLog(@"广告曝光成功 %s", __func__);
}

/// 广告展示失败
- (void)ad_FailedWithError:(NSError *)error description:(NSDictionary *)description{
    NSLog(@"广告展示失败 %s  error: %@ 详情:%@", __func__, error, description);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告加载失败", __func__]];
    [self showErrorWithDescription:description];
    [self loadAdWithState:AdState_LoadFailed];
    [self deallocAd];
}

/// 广告点击
- (void)ad_Clicked {
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告点击", __func__]];
    NSLog(@"广告点击 %s", __func__);
}

/// 广告关闭
- (void)ad_DidClose {
    NSLog(@"广告关闭了 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告关闭", __func__]];
    [self loadAdWithState:AdState_Normal];
    [self deallocAd];
}

/// 广告倒计时结束
- (void)ad_SplashOnAdCountdownToZero {
    NSLog(@"广告倒计时结束 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告倒计时结束", __func__]];
}

/// 点击了跳过
- (void)ad_SplashOnAdSkipClicked {
    NSLog(@"点击了跳过 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 点击了跳过", __func__]];
    [self loadAdWithState:AdState_Normal];
    [self deallocAd];
}

#pragma mark - lazy
- (MFAdSplash *)adSplash{
    if(!_adSplash){
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _adSplash = [[MFAdSplash alloc]initWithViewController:app.window.rootViewController];
        _adSplash.delegate = self;
//        _adSplash.showLogoRequire = YES;
//        _adSplash.logoImage = [UIImage imageNamed:@"58"];
//        _adSplash.backgroundImage = [UIImage imageNamed:@"LaunchImage_img"];
        _adSplash.timeout = 5;
    }
    return _adSplash;
}

@end
