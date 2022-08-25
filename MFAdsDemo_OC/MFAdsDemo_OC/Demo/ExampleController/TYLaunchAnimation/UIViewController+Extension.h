//
//  UIViewController+Extension.h
//  howear
//
//  Created by cc on 2021/6/7.
//  Copyright © 2021 hutianhu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)

+ (UIViewController *)nibLaunchViewController;

/**
 当前显示控制器
 */
+ (UIViewController *) currentVC;

/// 获取Window
+(UIWindow *)getKeyWindow;

@end

NS_ASSUME_NONNULL_END
