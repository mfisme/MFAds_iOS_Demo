//
//  DemoInterstitialViewController.swift
//  MFAdsDemo_Swift
//
//  Created by cc on 2022/6/6.
//

class DemoInterstitialViewController : BaseViewController ,MFAdInterstitialDelegate {
    
    
    lazy var adInterstitial: MFAdInterstitial = {
        let adInterstitial = MFAdInterstitial.init(viewController: self)
        adInterstitial.delegate = self
        return adInterstitial
    }()
    
    var isAdLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "插屏广告";
    }
    
    override func handleClickLoadBtn() {
        super.handleClickLoadBtn()
        self.deallocAd()
        self.loadAdWithState(._Normal)
        self.isAdLoaded = false
        self.adInterstitial.loadAd()
        self.loadAdWithState(._Loading)
    }
    
    override func handleClickShowBtn() {
        if !self.isLoaded {
            return
        }
        self.adInterstitial.showAd()
    }
    
    override func handleClickLoadAndShowBtn() {
        super.handleClickLoadAndShowBtn()
        self.loadAdWithState(._Normal)
        self.isAdLoaded = false
        self.adInterstitial.loadAndShowAd()
        self.loadAdWithState(._Loading)
    }
    
    override func deallocAd() {
//        self.adInterstitial.delegate = nil
//        self.isAdLoaded = false
//        self.loadAdWithState(._Normal)
    }
}

// MARK: - MFAdInterstitialDelegate
extension DemoInterstitialViewController {
    
    /// 内部渠道开始加载时调用
    func ad_SupplierWillLoad(_ supplierId: String!) {
        self.showProcessWithText("内部渠道开始加载")
    }
    /// 选中tag
    func ad_SuccessSortTag(_ sortTag: String!) {
        self.showProcessWithText("选中了 rule \(String(describing: sortTag))")
    }
    /// 请求广告数据成功后调用
    func ad_loadSuccess() {
        self.isLoaded = true
        self.showProcessWithText("广告数据拉取成功")
        self.loadAdWithState(._LoadSucceed)
    }
    /// 广告加载失败
    func ad_FailedWithError(_ error: Error!, description: [AnyHashable : Any]!) {
        self.showProcessWithText("广告加载失败")
        self.showErrorWithDescription(description as NSDictionary?)
        self.loadAdWithState(._LoadFailed)
        self.deallocAd()
    }
    /// 广告曝光
    func ad_exposured() {
        self.showProcessWithText("广告曝光")
    }
    /// 广告点击
    func ad_clicked() {
        self.showProcessWithText("广告点击")
    }
    /// 广告关闭
    func ad_didClose() {
        self.showProcessWithText("广告关闭")
    }
    
}
