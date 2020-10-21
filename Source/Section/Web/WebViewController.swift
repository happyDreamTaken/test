//
//  WebViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    lazy var navigateBar = NavigateBar(frame: .zero)
    lazy var webView = WKWebView(frame: .zero)
    lazy var link = "http://www.baidu.com"
    var url:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(navigateBar)
        self.view.addSubview(webView)
        
        navigateBar.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *)
                          {
                              make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                          }else {
            make.top.equalTo(self.view.snp.top).offset(UIApplication.shared.statusBarFrame.height)
                          }
            make.height.equalTo(44)
            make.left.right.equalToSuperview()
        }
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(navigateBar.snp.bottom)
            make.left.equalTo(13)
            make.right.equalTo(-13)
            if #available(iOS 11.0, *)
                      {
                          make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                      }else {
            if UIDevice.isIphoneX {
                make.bottom.equalTo(self.view).offset(-34)
            }else {
                make.bottom.equalTo(self.view)
            }
                      }
        }
        
        self.view.backgroundColor = UIColor.white
        
        navigateBar.titleLabel.text = self.title ?? ""
        navigateBar.titleLabel.font = UIFont.systemFont(ofSize: 17)
        navigateBar.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
//        navigateBar.rightButton.setTitle("刷新", for: .normal)
//        navigateBar.rightButton.addTarget(self, action: #selector(refreshButtonDidClick), for: .touchUpInside)
        
        webView.navigationDelegate = self
        
        if let url = self.url {
            webView.load(URLRequest(url: url))
            return
        }
        
        if let url = URL(string: self.link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc func backButtonDidClick(){
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func refreshButtonDidClick(){
        self.webView.reload()
    }

}

extension WebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
//        if let title = webView.title {
//            self.navigateBar.titleLabel.text = title
//        }
    }

}
