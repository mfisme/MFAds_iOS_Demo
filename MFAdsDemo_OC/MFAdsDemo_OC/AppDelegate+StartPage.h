//
//  AppDelegate+StartPage.h
//  MFAdsDemo_OC
//
//  Created by cc on 2022/8/24.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (StartPage)

/// 开屏广告展示类型
@property (nonatomic,assign) SplashType  splashType;


/// 开启启动页
- (void)addStartPage;
/// 关闭启动页
- (void)removeStartPage;

@end

NS_ASSUME_NONNULL_END
