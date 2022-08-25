//
//  MFNavigationController.m
//  MFAdsDemo_OC
//
//  Created by cc on 2022/8/24.
//

#import "MFNavigationController.h"
#import <MFAdsAdspot/MFAdSplash.h>
#import "AppDelegate+StartPage.h"


@interface MFNavigationController ()<MFAdSplashDelegate>

@property(strong,nonatomic) MFAdSplash *adSplash;

@end

@implementation MFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /* 开屏广告注意点，首先需要load 待曝光成功后进行展示show  */
    [self.adSplash loadAd];
}
#pragma mark - MFAdSplashDelegate

/// 内部渠道开始加载时调用
- (void)ad_SupplierWillLoad:(NSString *)supplierId {

    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);
}

- (void)ad_SuccessSortTag:(NSString *)sortTag {
    NSLog(@"选中了 rule '%@' %s", sortTag,__func__);
}

/// 广告数据拉取成功
- (void)ad_loadSuccess {
    NSLog(@"广告数据拉取成功 %s", __func__);
    
    [self.adSplash showAd];
}

/// 广告数据拉取失败
- (void)ad_loadFailure:(NSError *)error {
    NSLog(@"广告数据拉取失败 %s - %@",__func__,error);
    [self deallocAd];
}
/// 广告曝光成功
- (void)ad_exposured {

    NSLog(@"广告曝光成功 %s", __func__);
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app removeStartPage];
}

/// 广告展示失败
- (void)ad_FailedWithError:(NSError *)error description:(NSDictionary *)description{
    NSLog(@"广告展示失败 %s  error: %@ 详情:%@", __func__, error, description);
    [self deallocAd];
}

/// 广告点击
- (void)ad_Clicked {
    NSLog(@"广告点击 %s", __func__);
}

/// 广告关闭
- (void)ad_DidClose {
    NSLog(@"广告关闭了 %s", __func__);
    [self deallocAd];
}

/// 广告倒计时结束
- (void)ad_SplashOnAdCountdownToZero {
    NSLog(@"广告倒计时结束 %s", __func__);
}

- (void)deallocAd {
    _adSplash = nil;
    _adSplash.delegate = nil;
}
#pragma mark - lazy
- (MFAdSplash *)adSplash{
    if(!_adSplash){
        _adSplash = [[MFAdSplash alloc]initWithViewController:self];
        _adSplash.delegate = self;
        _adSplash.showLogoRequire = YES;
        _adSplash.logoImage = [UIImage imageNamed:@"58"];
//        _adSplash.backgroundImage = [UIImage imageNamed:@"LaunchImage_img"];
        _adSplash.timeout = 5;
    }
    return _adSplash;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
