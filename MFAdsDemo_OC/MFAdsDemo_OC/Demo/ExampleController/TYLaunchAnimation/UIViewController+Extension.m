//
//  UIViewController+Extension.m
//  howear
//
//  Created by cc on 2021/6/7.
//  Copyright © 2021 hutianhu. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

+ (UIViewController *)nibLaunchViewController {
    UIViewController *launchViewController = nil;
    NSString *storyboardName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UILaunchStoryboardName"];
    if ([storyboardName length] > 0) {
        @try {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            launchViewController = [storyboard instantiateInitialViewController];
        } @catch (NSException *exception) {
        }
        
        if (!launchViewController) {
            @try {
                UIView *view = [[[NSBundle mainBundle] loadNibNamed:storyboardName owner:nil options:nil] firstObject];
                [view setFrame:[UIScreen mainScreen].bounds];
                launchViewController = [UIViewController new];
                [launchViewController.view addSubview:view];
            } @catch (NSException *exception) {
            }
        }
    }

    return launchViewController;
}

+ (UIViewController *) currentVC {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *win in windows) {
            if (win.windowLevel == UIWindowLevelNormal) {
                window = win;
                break;
            }
        }
    }
    id vc = window.rootViewController;
    return [self topVCWithCurrentVC:vc];
}

+ (UIViewController *) topVCWithCurrentVC: (UIViewController *) currentVC {
    if (currentVC == nil) {
        NSLog(@"🌶: 找不到当前控制器");
        return nil;
    }

    if (currentVC.presentedViewController) {
        return [self topVCWithCurrentVC:currentVC.presentedViewController];
    } else if ([currentVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)currentVC;
        if (tabBarVC.selectedViewController != nil) {
            return [self topVCWithCurrentVC:tabBarVC.selectedViewController];
        }
        return nil;
    } else if ([currentVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)currentVC;
        return [self topVCWithCurrentVC:navVC.visibleViewController];
    } else {
        return currentVC;
    }
}

/// 获取 KeyWindow
+ (UIWindow *)getKeyWindow{
    
    if([[[UIApplication sharedApplication] delegate] window]){
        return [[[UIApplication sharedApplication] delegate] window];
    }else {
        if (@available(iOS 13.0,*)) {
            NSArray *arr = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *windowScene =  (UIWindowScene *)arr[0];
            UIWindow *mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
            if(mainWindow){
                return mainWindow;
            }else{
                return [UIApplication sharedApplication].windows.lastObject;
            }
        }else {
            return [UIApplication sharedApplication].keyWindow;
        }
    }
}

@end
