//
//  NavigationController.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    static let shared:NavigationController = {
        
//        let controller = NavigationController(rootViewController: ShareDetailViewController());
        let controller = NavigationController(rootViewController: TabBarController.shared);
        if false == User.shared.didLogin() {
            controller.pushViewController(RegisterViewController(), animated: false)
        }else{
            IvyGateServerAPI.shared.token = User.shared.token
        }
        controller.isNavigationBarHidden = true
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(LoadView())
        VersionManager.shared.requestVersionInfo()
    }
    //
    func userTokenDidInvalid(){
        if User.shared.didLogin() {
            VpnManager.shared.disconnect()
            User.shared.resetUserInfo()
            self.pushViewController(RegisterViewController(), animated: false)
        }
    }

}
