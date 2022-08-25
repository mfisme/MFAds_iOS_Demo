//
//  DemoRewardVideoViewController.m
//  MFAdsSDKDemo
//
//  Created by CherryKing on 2020/1/3.
//  Copyright © 2020 BAYESCOM. All rights reserved.
//

#import "DemoRewardVideoViewController.h"

#import <MFAdsAdspot/MFAdRewardVideo.h>
@interface DemoRewardVideoViewController () <MFAdRewardVideoDelegate>
@property (nonatomic, strong) MFAdRewardVideo *adRewardVideo;
@property (nonatomic) bool isAdLoaded; // 激励视频播放器 采用的是边下边播的方式, 理论上拉取数据成功 即可展示, 但如果网速慢导致缓冲速度慢, 则激励视频会出现卡顿
                                       // 广点通推荐在 ad_RewardVideoOnAdVideoCached 视频缓冲完成后 在掉用showad
@end

@implementation DemoRewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"激励视频";
    self.dic = [[AdDataJsonManager shared] loadAdDataWithType:JsonDataType_rewardVideo];
}

- (void)loadAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    [self.adRewardVideo loadAd];
    [self loadAdWithState:AdState_Loading];
}

- (void)showAd {
    if (!self.adRewardVideo) {
        [DemoUtils showToast:@"请先加载广告"];
        return;
    }
    [self.adRewardVideo showAd];
}

- (void)loadAndShowAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    [self.adRewardVideo loadAndShowAd];
    [self loadAdWithState:AdState_Loading];
}

- (void)deallocAd {
    self.adRewardVideo = nil;
    self.adRewardVideo.delegate = nil;
    self.isLoaded = NO;
    [self loadAdWithState:AdState_Normal];
}

#pragma mark - MFAdRewardVideoDelegate
/// 广告数据加载成功
- (void)ad_loadSuccess {
    NSLog(@"广告数据拉取成功, 正在缓存... %s", __func__);
    [DemoUtils showToast:@"广告加载成功"];
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告数据拉取成功", __func__]];
}

/// 视频缓存成功
- (void)ad_RewardVideoOnAdVideoCached {
    NSLog(@"视频缓存成功 %s", __func__);
    [DemoUtils showToast:@"视频缓存成功"];
    self.isLoaded = YES;
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 视频缓存成功", __func__]];
    [self loadAdWithState:AdState_LoadSucceed];
}

/// 到达激励时间
- (void)ad_RewardVideoAdDidRewardEffective {
    NSLog(@"到达激励时间 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 到达激励时间", __func__]];
}

/// 广告曝光
- (void)ad_Exposured {
    NSLog(@"广告曝光回调 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告曝光回调", __func__]];
}

/// 广告点击
- (void)ad_Clicked {
    NSLog(@"广告点击 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告点击", __func__]];
}

/// 广告加载失败
- (void)ad_FailedWithError:(NSError *)error description:(NSDictionary *)description{
    NSLog(@"广告展示失败 %s  error: %@ 详情:%@", __func__, error,description);
    [DemoUtils showToast:@"广告加载失败"];
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告加载失败", __func__]];
    [self showErrorWithDescription:description];
    [self loadAdWithState:AdState_LoadFailed];
    [self deallocAd];
}

/// 内部渠道开始加载时调用
- (void)ad_SupplierWillLoad:(NSString *)supplierId {
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 内部渠道开始加载", __func__]];
}

/// 广告关闭
- (void)ad_DidClose {
    NSLog(@"广告关闭了 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告关闭了", __func__]];
    [self deallocAd];
}

/// 播放完成
- (void)ad_RewardVideoAdDidPlayFinish {
    NSLog(@"播放完成 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 播放完成", __func__]];
}

- (void)ad_SuccessSortTag:(NSString *)sortTag {
    NSLog(@"选中了 rule '%@' %s", sortTag,__func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 选中了 rule '%@' ", __func__, sortTag]];
}

#pragma mark - lazy
- (MFAdRewardVideo *)adRewardVideo{
    if(!_adRewardVideo){
        _adRewardVideo = [[MFAdRewardVideo alloc] initWithViewController:self];
        _adRewardVideo.delegate = self;
    }
    return _adRewardVideo;
}
@end
