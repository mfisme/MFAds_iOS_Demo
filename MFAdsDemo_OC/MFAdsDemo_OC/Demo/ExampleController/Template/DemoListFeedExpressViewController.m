//
//  DemoListFeedExpressViewController.m
//  MFAdsDebug
//
//  Created by cc on 2022/8/30.
//

#import "DemoListFeedExpressViewController.h"
#import <MFAdsAdspot/MFAdNativeExpress.h>
#import <MFAdsAdspot/MFAdNativeExpressView.h>

@interface DemoListFeedExpressViewController ()<UITableViewDelegate, UITableViewDataSource, MFAdNativeExpressDelegate> {
    BOOL _isLoadAndShow;
    BOOL _isShowLogView;
    CGFloat _navAndStateBarHeight;
}

@property (strong,nonatomic) MFAdNativeExpress *advanceFeed;
@property (nonatomic, strong) NSMutableArray *dataArrM;
@property (nonatomic, strong) NSMutableArray *arrViewsM;
@property (nonatomic, assign) BOOL isLoadAndShow;
@property (nonatomic, assign) BOOL isShowLogView;
/// 视图容器
@property(nonatomic, strong) UIView *containerView;
@end


@implementation DemoListFeedExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"原生";
    
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    
    _navAndStateBarHeight = navHeight + statusHeight;
    
    self.textV.frame = CGRectMake(0,0 - 300, self.view.frame.size.width, 300);
    self.dic = [[AdDataJsonManager shared] loadAdDataWithType:JsonDataType_nativeExpress];

    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"显示log信息" style:UIBarButtonItemStylePlain target:self action:@selector(showLogView)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)loadAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    _isLoadAndShow = NO;
    self.dataArrM = [NSMutableArray array];
    [self.advanceFeed loadAd];
    [self loadAdWithState:AdState_Loading];
}

- (void)showAd {
    if (!self.advanceFeed || !self.isLoaded || self.arrViewsM.count == 0) {
        return;
    }
    [self showNativeAd];
}

- (void)loadAndShowAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    _isLoadAndShow = YES;
    self.dataArrM = [NSMutableArray array];
    [self.advanceFeed loadAndShowAd];
    [self loadAdWithState:AdState_Loading];
}

- (void)deallocAd {
    if (_advanceFeed) {
        _advanceFeed.delegate = nil;
        _advanceFeed = nil;
    }
    self.isLoaded = NO;
    [self.dataArrM removeAllObjects];
    [self.arrViewsM removeAllObjects];
    [self loadAdWithState:AdState_Normal];
}

// 信息流广告比较特殊, 渲染逻辑需要自行处理
- (void)showNativeAd {
    for (NSInteger i = 0; i < self.arrViewsM.count; i++) {
        MFAdNativeExpressView *view = self.arrViewsM[i];
        [view render];
        [_dataArrM addObject:self.arrViewsM[i]];
    }
    
    if (_dataArrM.count <= 0) {
        return;
    }
    
    [_containerView removeFromSuperview];
    UIView *view = [_dataArrM.firstObject expressView];
    self.containerView = view;
    [self.view addSubview:self.containerView];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(330);
    }];
}

- (void)showLogView {
    [UIView animateWithDuration:0.2 animations:^{
        self.textV.frame = CGRectMake(0,((self->_isShowLogView = !self->_isShowLogView) ? self->_navAndStateBarHeight : -300 ), self.view.frame.size.width, 300);
        self.navigationItem.rightBarButtonItem.title = self->_isShowLogView ? @"隐藏log信息":@"显示log信息";
    }];
}

#pragma mark - MFAdNativeExpressDelegate

/// 内部渠道开始加载时调用
- (void)easyAdSupplierWillLoad:(NSString *)supplierId {
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 内部渠道开始加载", __func__]];
}

// 选中渠道
- (void)easyAdSuccessSortTag:(NSString *)sortTag {
    NSLog(@"选中了 rule '%@' %s", sortTag,__func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 选中了 rule '%@' ", __func__, sortTag]];
}

/// 广告数据拉取成功
- (void)ad_NativeExpressOnAdLoadSuccess:(nullable NSArray<MFAdNativeExpressView *> *)views {
    NSLog(@"广告拉取成功 %s", __func__);
    self.arrViewsM = [NSMutableArray arrayWithArray:views];
    
    if (_isLoadAndShow) {
        [self showNativeAd];
    }
    
    self.isLoaded = YES;
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告拉取成功", __func__]];
    [self loadAdWithState:AdState_LoadSucceed];
}

/// 广告数据拉取失败
- (void)ad_NativeExpressOnAdLoadFailWithError:(NSError *_Nullable)error {
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告加载失败", __func__]];
    [self loadAdWithState:AdState_LoadFailed];
    [self deallocAd];
}
/// 广告渲染成功
- (void)ad_NativeExpressOnAdRenderSuccess:(nullable MFAdNativeExpressView *)adView {
    NSLog(@"广告渲染成功 %s %@", __func__, adView);
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(adView.expressView.frame.size.height);
    }];
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告渲染成功", __func__]];
}
/// 广告渲染失败
- (void)ad_NativeExpressOnAdRenderFail:(nullable MFAdNativeExpressView *)adView withError:(NSError *_Nullable)error {
    NSLog(@"广告渲染失败 %s %@", __func__, adView);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告渲染失败", __func__]];
    [_dataArrM removeObject: adView];
}
/// 广告视图为空
- (void)ad_NativeExpressOnAdGetViewIsEmpty {
    NSLog(@"广告视图为空");
}
/// 广告曝光
- (void)ad_NativeExpressOnAdShow:(nullable MFAdNativeExpressView *)adView {
    NSLog(@"广告曝光 %s", __func__);
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(adView.expressView.frame.size.height);
    }];
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告曝光成功", __func__]];
}
/// 广告点击
- (void)ad_NativeExpressOnAdClicked:(nullable MFAdNativeExpressView *)adView {
    NSLog(@"广告点击 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告点击", __func__]];
}
/// 广告被关闭 (注: 百度广告(百青藤), 不支持该回调, 若使用百青藤,则该回到功能请自行实现)
- (void)ad_NativeExpressOnAdClosed:(nullable MFAdNativeExpressView *)adView {
    NSLog(@"广告关闭 %s", __func__);
    [_dataArrM removeObject: adView];
}

#pragma mark - lazy
- (MFAdNativeExpress *)advanceFeed{
    if(!_advanceFeed){
        _advanceFeed = [[MFAdNativeExpress alloc]initWithViewController:self adSize:CGSizeMake(self.view.bounds.size.width, 0)];
        _advanceFeed.delegate = self;
    }
    return _advanceFeed;
}

@end
