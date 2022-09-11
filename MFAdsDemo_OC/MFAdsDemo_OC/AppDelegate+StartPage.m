//
//  AppDelegate+StartPage.m
//  MFAdsDemo_OC
//
//  Created by cc on 2022/8/24.
//

#import "AppDelegate+StartPage.h"
#import "UIView+TYLaunchAnimation.h"
#import "TYLaunchFadeScaleAnimation.h"
#import "UIImage+TYLaunchImage.h"
#import <objc/runtime.h>

static NSString *startPageImageViewKey = @"startPageImageViewKey";
static NSString *SplashTypeKey = @"SplashTypeKey";

#define maxLoadingStartPageTime 5


@interface AppDelegate (StartPage)
/// 图片
@property (nonatomic,strong) UIView *startPageView;

@end

@implementation AppDelegate (StartPage)

/// 开启启动页
- (void)addStartPage{
    
    __weak __typeof(self) weakSelf = self;
    self.splashType = SplashTypeStartAPP;
    if(!self.startPageView){
        self.startPageView = [UIImage getLaunchScreenView];
    }
    [self.startPageView showInWindowWithAnimation:[TYLaunchFadeScaleAnimation fadeAnimationWithDelay:maxLoadingStartPageTime] completion:^(BOOL finished) {
        [weakSelf removeStartPage];
    }];
}
/// 关闭启动页
- (void)removeStartPage{
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakSelf.startPageView){
            weakSelf.splashType = SplashTypeCloseAd;
            [weakSelf.startPageView removeFromSuperview];
            weakSelf.startPageView = nil;
        }
    });
}
#pragma mark - setter/getter

- (UIView *)startPageView {
    return objc_getAssociatedObject(self, &startPageImageViewKey);
}
- (void)setStartPageView:(UIView *)startPageView {
    objc_setAssociatedObject(self, &startPageImageViewKey, startPageView, OBJC_ASSOCIATION_RETAIN);
}
- (void)setSplashType:(SplashType)splashType {
    objc_setAssociatedObject(self, &SplashTypeKey, @(splashType), OBJC_ASSOCIATION_ASSIGN);
}
- (SplashType)splashType {
    return [objc_getAssociatedObject(self, &SplashTypeKey) intValue];
}
@end
