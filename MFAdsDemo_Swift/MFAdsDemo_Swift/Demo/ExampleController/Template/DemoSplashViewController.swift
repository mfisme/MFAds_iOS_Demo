//
//  DemoSplashViewController.swift
//  MFAdsDemo_Swift
//

class DemoSplashViewController : BaseViewController,MFAdSplashDelegate {
    
    lazy var splash: MFAdSplash = {
        let splash: MFAdSplash = MFAdSplash.init(viewController: self)
        splash.delegate = self
        splash.timeout = 5
        return splash
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "开屏广告";
        self.isOnlyLoad = true;
        self.isAdLoadAndShow = false;
    }
    
    override func handleClickLoadAndShowBtn() {
        super.handleClickLoadAndShowBtn()
        self.loadAndShowSplashAd()
    }
    override func handleClickLoadBtn() {
        super.handleClickLoadBtn()
        self.loadAd()
    }
    
    override func handleClickShowBtn() {
        super.handleClickShowBtn()
        self.showAd()
    }
    func showAd() {
        self.splash.showAd();
    }
    func loadAd() {
        self.deallocAd()
        self.loadAdWithState(._Normal)
        self.splash.loadAd()
        self.loadAdWithState(._Loading)
    }
    
    func loadAndShowSplashAd() {
        self.deallocAd()
        self.loadAdWithState(._Normal)
        self.splash.loadAndShowAd();
        self.loadAdWithState(._Loading)
    }
    
    override func deallocAd() {
//        self.splash = nil
//        self.splash.delegate = nil
    }
    
    
    // 广告数据拉取成功
    func ad_loadSuccess() {
        self.showAd()
        self.showProcessWithText("广告加载成功")
        self.loadAdWithState(._LoadSucceed)
    }
    
    // 广告数据拉去失败
    func ad_loadFailure(_ error: Error!) {
        self.showProcessWithText("广告加载失败")
        self.deallocAd()
    }
    
    // 广告曝光成功
    func ad_exposured() {
        self.showProcessWithText("广告曝光成功")
    }
    
    // 广告加载失败
    func ad_FailedWithError(_ error: Error!, description: [AnyHashable : Any]!) {
        self.showProcessWithText("广告加载失败")
        self.showErrorWithDescription(description as NSDictionary?)
        self.loadAdWithState(._LoadFailed)
        self.deallocAd()
    }
    
    // 内部渠道开始加载
    func ad_SupplierWillLoad(_ supplierId: String!) {
        self.showProcessWithText("内部渠道开始加载时调用")
    }
    
    // 广告点击
    func ad_clicked() {
        self.showProcessWithText("广告点击")
    }
    
    // 广告关闭
    func ad_didClose() {
        self.showProcessWithText("广告关闭")
        self.loadAdWithState(._Normal)
        self.deallocAd()
    }
    
    // 广告倒计时
    func ad_SplashOnAdCountdownToZero() {
        self.showProcessWithText("广告倒计时结束")
    }
    // 点击跳过
    func ad_SplashOnAdSkipClicked() {
        self.showProcessWithText("点击跳过")
        self.loadAdWithState(._Normal)
        self.deallocAd()
    }
    
    // 选中sortTag
    func ad_SuccessSortTag(_ sortTag: String!) {
        self.showProcessWithText("选中了\(sortTag ?? "")")
    }
}

//extension DemoSplashViewController : MFAdSplashDelegate {
//    // 广告数据拉取成功
//    func ad_loadSuccess() {
//        self.splash.showAd();
//        self.showProcessWithText("广告加载成功")
//        self.loadAdWithState(._LoadSucceed)
//    }
//
//    // 广告数据拉去失败
//    func ad_loadFailure(_ error: Error!) {
//        self.showProcessWithText("广告加载失败")
//        self.deallocAd()
//    }
//
//    // 广告曝光成功
//    func ad_exposured() {
//        self.showProcessWithText("广告曝光成功")
//    }
//
//    // 广告加载失败
//    func ad_FailedWithError(_ error: Error!, description: [AnyHashable : Any]!) {
//        self.showProcessWithText("广告加载失败")
//        self.showErrorWithDescription(description as NSDictionary?)
//        self.loadAdWithState(._LoadFailed)
//        self.deallocAd()
//    }
//
//    // 内部渠道开始加载
//    func ad_SupplierWillLoad(_ supplierId: String!) {
//        self.showProcessWithText("内部渠道开始加载时调用")
//    }
//
//    // 广告点击
//    func ad_clicked() {
//        self.showProcessWithText("广告点击")
//    }
//
//    // 广告关闭
//    func ad_didClose() {
//        self.showProcessWithText("广告关闭")
//        self.loadAdWithState(._Normal)
//        self.deallocAd()
//    }
//
//    // 广告倒计时
//    func ad_SplashOnAdCountdownToZero() {
//        self.showProcessWithText("广告倒计时结束")
//    }
//    // 点击跳过
//    func ad_SplashOnAdSkipClicked() {
//        self.showProcessWithText("点击跳过")
//        self.loadAdWithState(._Normal)
//        self.deallocAd()
//    }
//
//    // 选中sortTag
//    func ad_SuccessSortTag(_ sortTag: String!) {
//        self.showProcessWithText("选中了\(sortTag ?? "")")
//    }
//}
