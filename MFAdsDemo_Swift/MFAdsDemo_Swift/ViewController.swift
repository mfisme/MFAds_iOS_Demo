//
//  ViewController.swift
//  MFAdsDemo_Swift
//
//  Created by cc on 2022/5/30.
//

import UIKit
#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif
import AdSupport

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var adsNum : String = ""
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var dataArray: Array<[String : String]> = [
        ["title":"开屏", "targetVCName": "DemoSplashViewController"],
        ["title":"Banner", "targetVCName": "DemoBannerViewController"],
        ["title":"插屏", "targetVCName": "DemoInterstitialViewController"],
        ["title":"激励视频", "targetVCName": "DemoRewardVideoViewController"],
//        ["title":"信息流", "targetVCName": "DemoBannerViewController"],
//        ["title":"原生", "targetVCName": "DemoBannerViewController"],
        ["title":"IDFA", "targetVCName": ""]
    ]
    
    private let reusableTableViewCellID = "DemoTableIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.addSubview(tableView)
        tableView.reloadData()
    }
    
    // MARK: - 获取IDFA
    func getIDFA() -> String {
        
        if self.adsNum.count > 0 {
            return self.adsNum
        }
        
        var idfa = ""
        idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        self.adsNum = idfa
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: self.dataArray.count - 1, section: 0))
        cell?.detailTextLabel?.text = idfa
        return idfa
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reusableTableViewCellID)
        cell.textLabel?.text = self.dataArray[indexPath.row]["title"]
        var subStr = ""
        if indexPath.row == self.dataArray.count - 1{
            subStr = self.getIDFA()
        }
        cell.detailTextLabel?.text = subStr
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // heightForRowAtIndexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let className: String = dataArray[indexPath.row]["targetVCName"] ?? ""
        let class_VC = classFromString(className)
        present(class_VC, animated: true)
    }
    
    func classFromString(_ className:String) -> UIViewController{
        //1、获swift中的命名空间名
        var name = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String
        //2、如果包名中有'-'横线这样的字符，在拿到包名后，还需要把包名的'-'转换成'_'下横线
        name = name?.replacingOccurrences(of: "-", with: "_")
        //3、拼接命名空间和类名，”包名.类名“
        let fullClassName = name! + "." + className
        //通过NSClassFromString获取到最终的类，由于NSClassFromString返回的是AnyClass，这里要转换成UIViewController.Type类型
        guard let classType = NSClassFromString(fullClassName) as? UIViewController.Type  else{
            fatalError("转换失败")
        }
        return classType.init()
    }
}
