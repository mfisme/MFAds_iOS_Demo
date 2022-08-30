//
//  DemoBannerViewController.m
//  Example
//

#import "DemoBannerViewController.h"
#import <MFAdsAdspot/MFAdBanner.h>

@interface DemoBannerViewController () <MFAdBannerDelegate>
@property (nonatomic, strong) MFAdBanner *adBanner;
@property (nonatomic, strong) UIView *contentV;

@end

@implementation DemoBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Banner";
    self.dic = [[AdDataJsonManager shared] loadAdDataWithType:JsonDataType_banner];
    self.isOnlyLoad = NO;
}

- (void)loadAndShowAd{
    [super loadAndShowAd];
 
//    [self.view addSubview:self.contentV];
    [self loadAdWithState:AdState_Normal];
    [self.adBanner loadAndShowAd];
    [self loadAdWithState:AdState_Loading];
}

- (void)deallocAd {
    self.contentV = nil;
    self.adBanner = nil;
    self.adBanner.delegate = nil;
}

#pragma mark - MFAdBannerDelegate

/// 内部渠道开始加载时调用
- (void)ad_SupplierWillLoad:(NSString *)supplierId {
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 内部渠道开始加载时调用", __func__]];
}

- (void)ad_SuccessSortTag:(NSString *)sortTag {
    NSLog(@"选中了 rule '%@' %s", sortTag,__func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 选中了 rule '%@' ", __func__, sortTag]];
}

/// 广告数据拉取成功回调
- (void)ad_loadSuccess {
    NSLog(@"广告数据拉取成功 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告拉取成功", __func__]];
    [self loadAdWithState:AdState_LoadSucceed];
}

- (void)ad_loadFailure:(NSError *)error {
    NSLog(@"广告数据拉取失败%@",error);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告加载失败", __func__]];
    [self loadAdWithState:AdState_LoadFailed];
}

/// 广告加载失败
- (void)ad_FailedWithError:(NSError *)error description:(NSDictionary *)description{
    NSLog(@"广告展示失败 %s  error: %@ 详情:%@", __func__, error, description);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告加载失败", __func__]];
    [self showErrorWithDescription:description];
    [self loadAdWithState:AdState_LoadFailed];
    [self deallocAd];
}

/// 广告曝光
- (void)ad_Exposured {
    NSLog(@"广告曝光回调 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告曝光成功", __func__]];
}

/// 广告点击
- (void)ad_Clicked {
    NSLog(@"广告点击 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告点击", __func__]];
}

/// 广告关闭回调
- (void)ad_DidClose {
    NSLog(@"广告关闭了 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告关闭了", __func__]];

}

#pragma mark - lazy
- (MFAdBanner *)adBanner{
    if(!_adBanner){
        _adBanner = [[MFAdBanner alloc] initWithAdViewController:self];
        _adBanner.delegate = self;
    }
    return _adBanner;
}

- (UIView *)contentV{
    if(!_contentV){
        _contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 600,50)];
    }
    return _contentV;
}
@end
