//
//  TabBarController.swift
//  IvyGate
//
//  Created by tjvs on 2019/9/3.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    static let shared:TabBarController = TabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor.RGBHex(0x00C97E)
        
        let homeVC = HomeViewController.shared
        self.addChildViewController(child: homeVC, title: "首页", image:"tab_home" , selected:"tab_home_" )
        
        let vipVC = VIPViewController.shared
        self.addChildViewController(child: vipVC, title: "会员", image:"tab_vip" , selected:"tab_vip_" )
        
        let mineVC = MineViewController.shared
        self.addChildViewController(child: mineVC, title: "我的", image:"tab_mine" , selected:"tab_mine_" )
        
        self.selectedIndex = 0
       
    }
    
    
    func addChildViewController(child:UIViewController,title:String,image:String,selected:String)  {
        
        var normalImage = UIImage(named:image)
        normalImage = normalImage?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        var selectedImage = UIImage(named:selected )
        selectedImage = selectedImage?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        child.tabBarItem = UITabBarItem(title: title, image: normalImage,selectedImage: selectedImage)
        
        self.addChild(child)
        
    }
}
