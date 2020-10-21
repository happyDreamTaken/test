//
//  SiteDetailViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/1.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit
import WebKit

class SiteDetailViewController: UIViewController {
    
    lazy var navigateView = NavigateBar(frame: .zero)
    lazy var webView = WKWebView(frame: .zero)
    lazy var link = ""
    lazy var siteTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(navigateView)
        self.view.addSubview(webView)
        
        navigateView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *)
                          {
                              make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                          }else {
            make.top.equalTo(self.view.snp.top).offset(UIApplication.shared.statusBarFrame.height)
                          }
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(navigateView.snp.bottom)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalToSuperview()
        }
        
        navigateView.titleLabel.text = siteTitle
        navigateView.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        
        if let url = URL(string: self.link) {
            webView.load(URLRequest(url: url))
        }
    }
    
    @objc func backButtonDidClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
