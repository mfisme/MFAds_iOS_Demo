//
//  BaseViewController.swift
//  MFAdsDemo_Swift
//
//  Created by cc on 2022/5/31.
//

import UIKit

class BaseViewController : UIViewController {
    
    enum AdState : Int {
        case _Normal // 未加载
        case _Loading // 加载中
        case _LoadSucceed // 加载成功
        case _LoadFailed // 加载失败
    }
    
    public var dic: NSDictionary = [:]
    // 是否正在加载
    public var isLoaded: Bool = false
    
    public lazy var btnLoad: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 100, width: 140, height: 40))
        button.backgroundColor = .blue
        button.setTitle("加载广告", for: .normal)
        button.addTarget(self, action: #selector(handleClickLoadBtn), for: .touchUpInside)
        return button
    }()
    
    public lazy var btnShow: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 160, width: 140, height: 40))
        button.backgroundColor = .blue
        button.setTitle("显示广告", for: .normal)
        button.addTarget(self, action: #selector(handleClickShowBtn), for: .touchUpInside)
        return button
    }()
    
    public lazy var btnLoadAndShow: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 220, width: 140, height: 40))
        button.backgroundColor = .blue
        button.setTitle("加载并显示广告", for: .normal)
        button.addTarget(self, action: #selector(handleClickLoadAndShowBtn), for: .touchUpInside)
        return button
    }()
    
    public lazy var labNotify: UILabel = {
        let lable = UILabel(frame: CGRect(x: 10, y: 280, width: UIScreen.main.bounds.width, height: 40))
        return lable
    }()
    
    public lazy var textV: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 330, width: self.view.frame.size.width, height: self.view.frame.size.height - self.labNotify.frame.maxY - 20))
        return textView
    }()
    
    public var tempText: String = ""
    // 是否展示某些按钮
    public var isAdLoadAndShow: Bool = false {
      
        didSet {
            if !isAdLoadAndShow {
                btnLoadAndShow.isHidden = !isAdLoadAndShow
            }
            print("在 didSet 中, value = \(isAdLoadAndShow), oldValue = \(oldValue)")
        }
    }
    
    
    // 是否展示某些按钮
    public var isOnlyLoad: Bool = false {
      
        didSet {
            if !isOnlyLoad {
                btnLoad.isHidden = !isOnlyLoad
                btnShow.isHidden = !isOnlyLoad
            }
            print("在 didSet 中, value = \(isOnlyLoad), oldValue = \(oldValue)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.versionAdaptation()
        self.setupUI()
        loadAdWithState(._Normal)
    }
    
    // MARK: - setupUI
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.btnLoad)
        self.view.addSubview(self.btnShow)
        self.view.addSubview(self.btnLoadAndShow)
        self.view.addSubview(self.labNotify)
        self.view.addSubview(self.textV)
    }
    
    // MARK: - event
    // 加载广告
    @objc func handleClickLoadBtn() {
        self.clearText()
        loadAdWithState(._Normal)
    }
    // 显示广告
    @objc func handleClickShowBtn() {
        
    }
    // 加载并显示广告
    @objc func handleClickLoadAndShowBtn() {
        self.clearText()
        loadAdWithState(._Normal)
    }
    // 释放
    func deallocAd() {
        
    }
    // 加载状态
    func loadAdWithState(_ state: AdState) {
        self.labNotify.text = ""
        switch (state) {
        case ._Normal:
            self.labNotify.text = "未加载广告"
        case ._Loading:
            self.labNotify.text = "广告加载中..."
        case ._LoadSucceed:
            self.labNotify.text = "广告加载成功"
        case ._LoadFailed:
            self.labNotify.text = "广告加载失败"
        }
    }
    
    func showProcessWithText(_ text: String) {
        tempText = (tempText as String) + "\r\n\(text)"
        self.textV.text = tempText as String;
    }
    
    func clearText() {
        tempText = ""
        self.textV.text = tempText as String
    }
    
    func showErrorWithDescription(_ description: NSDictionary?) {
        
        if description == nil {
            return
        }
    
        let highlightText = self.getSianKey(withDic: description as? [String : NSError])
        tempText = tempText.appending(String(", 失败原因如下:\r\n\(highlightText)"))
        self.textV.text = tempText as String
    }
    
    // MARK: - prinvate
    /// 适配iOS
    func versionAdaptation() {
        if #available(iOS 15, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .regular)
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationBar.standardAppearance = appearance
        }
    }
    
    // 拼接错误内容返回字符串
    func getSianKey(withDic dic: [String : NSError]?) -> String  {
        //按字典排序
        let arr = dic?.keys
        guard arr != nil else {
            return ""
        }
        
        let tempArr = arr?.sorted(by: { a1, a2 in
            let result = a1.compare(a2)
            return result == .orderedDescending
        })
        
        guard tempArr != nil else {
            print(tempArr ?? "为空")
            return ""
        }
        
        //拼接字符串
        var strArray: [String] = []
        for(_ , value) in tempArr!.enumerated() {

            var appendStr = ""
            appendStr = value
            let par: NSError? = dic?[value] as? NSError ?? nil
            
            if dic?[value] != nil {
                appendStr = appendStr + (par?.userInfo.description ?? "")
                let code = par?.code;
                var desc = par?.userInfo[NSLocalizedDescriptionKey];
                
                if desc == nil {
                    desc = par?.userInfo["desc"]
                }
                
                let errorInfo = "\(value): code: \(String(describing: code ?? 0)) 错误详情:\(String(describing: desc))"
                strArray.append(errorInfo)
           }
        }
        let str = strArray.joined(separator: "\r\n")
        return str
    }
}
