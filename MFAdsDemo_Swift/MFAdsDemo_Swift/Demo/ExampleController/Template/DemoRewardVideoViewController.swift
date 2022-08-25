//
//  DemoRewardVideoViewController.swift
//  MFAdsDemo_Swift
//
//  Created by cc on 2022/6/6.
//

class DemoRewardVideoViewController : BaseViewController,MFAdRewardVideoDelegate {
    
    lazy var adRewardVideo: MFAdRewardVideo = {
        let adRewardVideo = MFAdRewardVideo(viewController: self)
        adRewardVideo.delegate = self
        return adRewardVideo
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "激励视频";
    }
    
    override func handleClickLoadBtn() {
        super.handleClickLoadBtn()
        self.deallocAd()
        self.loadAdWithState(._Normal)
        self.adRewardVideo.loadAd()
        self.loadAdWithState(._Loading)
    }
    override func handleClickShowBtn() {
        if !self.isLoaded   {
            return
        }
        self.adRewardVideo.showAd()
    }
    
    override func handleClickLoadAndShowBtn() {
        super.handleClickLoadAndShowBtn()
        self.deallocAd()
        self.loadAdWithState(._Normal)
        self.adRewardVideo.loadAndShowAd()
        self.loadAdWithState(._Loading)
    }
    override func deallocAd() {
//        self.adRewardVideo.delegate = nil
        self.isLoaded = true
//        self.loadAdWithState(._Normal)
    }
}

// MARK: - MFAdRewardVideoDelegate
extension DemoRewardVideoViewController {
    // 广告加载成功
    func ad_loadSuccess() {
        self.showProcessWithText("广告数据拉取成功")
    }
    // 加载失败
    func ad_FailedWithError(_ error: Error!, description: [AnyHashable : Any]!) {
        self.showProcessWithText("广告加载失败")
        self.showErrorWithDescription(description as NSDictionary?)
        self.loadAdWithState(._LoadFailed)
        self.deallocAd()
    }
    // 视频缓存成功
    func ad_RewardVideoOnAdVideoCached() {
        self.isLoaded = true
        self.showProcessWithText("视频缓存成功")
        self.loadAdWithState(._LoadSucceed)
    }
    // 到达激励时间
    func ad_RewardVideoAdDidRewardEffective() {
        self.showProcessWithText("到达激励时间")
    }
    // 播放完成
    func ad_RewardVideoAdDidPlayFinish() {
        self.showProcessWithText("视频播放完成")
    }
    // 曝光
    func ad_exposured() {
        self.showProcessWithText("视频曝光")
    }
    // 点击
    func ad_clicked() {
        self.showProcessWithText("视频点击")
    }
    // 关闭
    func ad_didClose() {
        self.showProcessWithText("视频关闭")
        self.deallocAd()
    }
    // 内部渠道开始加载
    func ad_SupplierWillLoad(_ supplierId: String!) {
        self.showProcessWithText("内部渠道开始加载")
    }
    // tag
    func ad_SuccessSortTag(_ sortTag: String!) {
        self.showProcessWithText("选中了 rule \(String(describing: sortTag))")
    }
    
}
