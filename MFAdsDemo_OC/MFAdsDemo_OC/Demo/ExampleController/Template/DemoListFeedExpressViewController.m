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

@property (strong, nonatomic) UITableView *tableView;
@property (strong,nonatomic) MFAdNativeExpress *advanceFeed;
@property (nonatomic, strong) NSMutableArray *dataArrM;
@property (nonatomic, strong) NSMutableArray *arrViewsM;
@property (nonatomic, assign) BOOL isLoadAndShow;
@property (nonatomic, assign) BOOL isShowLogView;

@end


@implementation DemoListFeedExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"信息流";
    
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    
    _navAndStateBarHeight = navHeight + statusHeight;
    
    self.textV.frame = CGRectMake(0,0 - 300, self.view.frame.size.width, 300);
    self.dic = [[AdDataJsonManager shared] loadAdDataWithType:JsonDataType_nativeExpress];

    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"显示log信息" style:UIBarButtonItemStylePlain target:self action:@selector(showLogView)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(self.view.frame.size.height - 330));
    }];
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"splitnativeexpresscell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"nativeexpresscell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
}

- (void)loadAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    
    _isLoadAndShow = NO;
    
    self.dataArrM = [NSMutableArray array];
    
    self.advanceFeed = [[MFAdNativeExpress alloc] initWithJsonDic:self.dic viewController:self adSize:CGSizeMake(self.view.bounds.size.width, 0)];
    self.advanceFeed.delegate = self;
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
    
    self.advanceFeed = [[MFAdNativeExpress alloc] initWithJsonDic:self.dic viewController:self adSize:CGSizeMake(self.view.bounds.size.width, 0)];
    self.advanceFeed.delegate = self;
    [self.advanceFeed loadAndShowAd];
    [self loadAdWithState:AdState_Loading];
}

- (void)deallocAd {
    self.advanceFeed = nil;
    self.advanceFeed.delegate = nil;
    self.isLoaded = NO;
    [self.dataArrM removeAllObjects];
    [self.arrViewsM removeAllObjects];
    [self.tableView reloadData];
    [self loadAdWithState:AdState_Normal];

}

// 信息流广告比较特殊, 渲染逻辑需要自行处理
- (void)showNativeAd {
    for (NSInteger i = 0; i < self.arrViewsM.count; i++) {
        MFAdNativeExpressView *view = self.arrViewsM[i];
        [view render];
        [_dataArrM addObject:self.arrViewsM[i]];
    }
    [self.tableView reloadData];

}

- (void)showLogView {
    [UIView animateWithDuration:0.2 animations:^{
        self.textV.frame = CGRectMake(0,((_isShowLogView = !_isShowLogView) ? _navAndStateBarHeight : -300 ), self.view.frame.size.width, 300);
        self.navigationItem.rightBarButtonItem.title = _isShowLogView ? @"隐藏log信息":@"显示log信息";
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
    self.arrViewsM = [views mutableCopy];
    
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
//    [self showErrorWithDescription:description];
    [self loadAdWithState:AdState_LoadFailed];
    [self deallocAd];
}
/// 广告渲染成功
- (void)ad_NativeExpressOnAdRenderSuccess:(nullable MFAdNativeExpressView *)adView {
    NSLog(@"广告渲染成功 %s %@", __func__, adView);
    NSLog(@"adView.expressView.frame.size.height = %f",adView.expressView.frame.size.height);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告渲染成功", __func__]];
    [self.tableView reloadData];
}
/// 广告渲染失败
- (void)ad_NativeExpressOnAdRenderFail:(nullable MFAdNativeExpressView *)adView withError:(NSError *_Nullable)error {
    NSLog(@"广告渲染失败 %s %@", __func__, adView);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告渲染失败", __func__]];
    [_dataArrM removeObject: adView];
    [self.tableView reloadData];
}
/// 广告视图为空
- (void)ad_NativeExpressOnAdGetViewIsEmpty {
    NSLog(@"广告视图为空");
}
/// 广告曝光
- (void)ad_NativeExpressOnAdShow:(nullable MFAdNativeExpressView *)adView {
    NSLog(@"广告曝光 %s", __func__);
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
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArrM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ([_dataArrM[indexPath.row] expressView]).frame.size.height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"nativeexpresscell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *subView = (UIView *)[cell.contentView viewWithTag:1000];
    if ([subView superview]) {
        [subView removeFromSuperview];
    }
    UIView *view = [_dataArrM[indexPath.row] expressView];
    
    view.tag = 1000;
    [cell.contentView addSubview:view];
    cell.accessibilityIdentifier = @"nativeTemp_ad";
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    return cell;
}


@end
