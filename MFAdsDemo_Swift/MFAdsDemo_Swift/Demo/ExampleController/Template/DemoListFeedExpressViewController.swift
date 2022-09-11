//
//  DemoListFeedExpressViewController.swift
//  MFAdsDemo_Swift
//
//  Created by cc on 2022/9/9.
//

import Foundation
import SnapKit

class DemoListFeedExpressViewController : BaseViewController,MFAdNativeExpressDelegate {

    lazy var native: MFAdNativeExpress = {
        let native: MFAdNativeExpress = MFAdNativeExpress.init(viewController: self, adSize:CGSize(width: self.view.bounds.size.width, height: 0))
        native.delegate = self
        return native
    }()
    
    var arrViewsM: [MFAdNativeExpressView] = []
    var dataArrM: [MFAdNativeExpressView] = []

    var isLoadAndShow: Bool = false
    var isLoadeds: Bool = false

    var containerView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "原生";
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
        self.showNativeAd()
    }

    func loadAd() {
        self.deallocAd()
        self.loadAdWithState(._Normal)
        self.native.loadAd()
        self.loadAdWithState(._Loading)
    }
    
    func loadAndShowSplashAd() {
        self.deallocAd()
        self.loadAdWithState(._Normal)
        self.native.loadAndShowAd();
        self.loadAdWithState(._Loading)
    }
    
    override func deallocAd() {
    }
    
    func showNativeAd() {
        for item in arrViewsM {
            let view: MFAdNativeExpressView = item
            view.render()
            dataArrM.append(item)
        }
        
        if dataArrM.count <= 0 {
            return
        }
        
        containerView.removeFromSuperview()
        let view = dataArrM[0].expressView
        self.containerView = view
        self.view.addSubview(self.containerView)
        
        self.containerView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(330);
        }
    }

    // MARK: - MFAdNativeExpressDelegate
    // 数据加载成功
    func ad_NativeExpress(onAdLoadSuccess views: [MFAdNativeExpressView]?) {
        print("广告拉取成功")
        arrViewsM = views ?? [MFAdNativeExpressView]()
        if isLoadAndShow {
            self.showNativeAd()
        }
        isLoadeds = true
        self.showProcessWithText("广告拉取成功")
        self.loadAdWithState(._LoadSucceed)
    }
    // 数据加载失败
    func ad_NativeExpressOnAdLoadFailWithError(_ error: Error?) {
        self.showProcessWithText("广告加载失败")
        self.loadAdWithState(._LoadFailed)
        self.deallocAd()
    }
    // 广告渲染成功
    func ad_NativeExpress(onAdRenderSuccess adView: MFAdNativeExpressView?) {
        print("广告渲染成功")
        self.containerView.snp.makeConstraints { make in
            make.height.equalTo(adView?.expressView.frame.size.height ?? 0)
        }
        self.showProcessWithText("广告渲染成功")
    }
    // 广告渲染失败
    func ad_NativeExpress(onAdRenderFail adView: MFAdNativeExpressView?, withError error: Error?) {
        print("广告渲染失败")
        self.showProcessWithText("广告渲染失败")
        dataArrM.removeAll()
    }
    // 广告爆光成功
    func ad_NativeExpress(onAdShow adView: MFAdNativeExpressView?) {
        print("广告曝光")
        self.containerView.snp.makeConstraints { make in
            make.height.equalTo(adView?.expressView.frame.size.height ?? 0)
        }
        self.showProcessWithText("广告曝光成功")
    }
    // 广告视图为空
    func ad_NativeExpressOnAdGetViewIsEmpty() {
        print("广告视图为空")
    }
    // 广告关闭
    func ad_NativeExpress(onAdClosed adView: MFAdNativeExpressView?) {
        print("广告关闭");
        dataArrM.removeAll()
    }
    
    // 广告点击
    func ad_NativeExpress(onAdClicked adView: MFAdNativeExpressView?) {
        print("广告点击");
        self.showProcessWithText("广告点击")
    }
}
