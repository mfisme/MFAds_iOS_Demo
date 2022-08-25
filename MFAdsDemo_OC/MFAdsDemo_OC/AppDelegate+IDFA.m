//
//  AppDelegate+IDFA.m
//  MFAdsDemo_OC
//
//  Created by cc on 2022/8/24.
//

#import "AppDelegate+IDFA.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>


@implementation AppDelegate (IDFA)

- (void)requestIDFA{
    
    if (@available(iOS 14, *)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // iOS14及以上版本需要先请求权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                
                switch (status) {
                    case ATTrackingManagerAuthorizationStatusDenied:{
                        
                        NSLog(@"用户拒绝");
                    }break;
                    case ATTrackingManagerAuthorizationStatusAuthorized:{
                        
                        NSLog(@"用户允许");
                        NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                        NSLog(@"%@",idfa);
                        
                    }  break;
                    case ATTrackingManagerAuthorizationStatusNotDetermined:
                    {
                        NSLog(@"用户为做选择或未弹窗");
                    }break;
                    default:
                        break;
                }
            }];
        });
    } else {
        // iOS14以下版本依然使用老方法
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"%@",idfa);
        } else {
            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
        }
    }
}
@end
