//
//  DemoBannerViewController.swift
//  MFAdsDemo_Swift
//
//  Created by cc on 2022/6/6.
//

class DemoBannerViewController : BaseViewController , MFAdBannerDelegate {
  
    
    lazy var adBanner:MFAdBanner = {
      
        let banner: MFAdBanner = MFAdBanner.init(adViewController: self)
        banner.delegate = self
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Banner";
        self.isAdLoadAndShow = true;
        self.isOnlyLoad = false;
    }
    
    override func handleClickLoadAndShowBtn() {
        super.handleClickLoadAndShowBtn()
        self.loadAdWithState(._Normal)
        self.adBanner.loadAndShowAd()
        self.loadAdWithState(._Loading)
    }
    override func deallocAd() {
        self.adBanner.delegate = nil
    }
}

// MARK: - MFAdBannerDelegate
extension DemoBannerViewController {

    // 内部渠道开始加载时调用
    func ad_SupplierWillLoad(_ supplierId: String!) {
        self.showProcessWithText("内部渠道开始加载时调用")
    }
    // 选中tag
    func ad_SuccessSortTag(_ sortTag: String!) {
        self.showProcessWithText("选中tag\(String(describing: sortTag))")
    }

    // 广告数据拉取成功回调
    func ad_loadSuccess() {
        self.showProcessWithText("广告拉取成功")
        self.loadAdWithState(._LoadSucceed)
    }
    // 广告数据加载失败
    func ad_loadFailure(_ error: Error!) {
        self.showProcessWithText("广告拉取失败")
        self.loadAdWithState(._LoadFailed)
    }
    // 广告加载失败
    func ad_FailedWithError(_ error: Error!, description: [AnyHashable : Any]!) {
        self.showProcessWithText("广告加载失败")
        self.showErrorWithDescription(description as NSDictionary?)
        self.loadAdWithState(._LoadFailed)
        self.deallocAd()
    }

    // 曝光
    func ad_exposured() {
        self.showProcessWithText("广告曝光成功")
    }
    // 点击
    func ad_clicked() {
        self.showProcessWithText("广告点击")
    }
    // 关闭
    func ad_didClose() {
        self.showProcessWithText("广告关闭")
    }
}
