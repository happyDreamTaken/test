//
//  AppDelegate.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit
import UserNotifications.UNNotification
import UserNotifications.UNNotificationRequest
import SwiftyJSON
import ShadowPath

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        _ = UMeng.shared
        Network.shared.start()
        
        let entiy = UMessageRegisterEntity.init()
        entiy.types = Int(UMessageAuthorizationOptions.badge.rawValue|UMessageAuthorizationOptions.alert.rawValue|UMessageAuthorizationOptions.sound.rawValue)
        
        registerNotifications(application)
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entiy) { (isOK, error) in
            
            
        }
        
        IvyInPurchSafeManager.safeManager.listenOrder()
        
        self.window = UIWindow(frame: UIScreen.main.bounds) 
        self.window?.rootViewController = NavigationController.shared
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Log.Info("codeboor \(url.absoluteString)")
        if url.absoluteString.hasPrefix("tencent") {
            return Tencent.shared.openURL(url: url)
        }else if url.absoluteString.hasPrefix("wx") {
            return Wechat.shared.openURL(url: url)
        }else if url.absoluteString.hasPrefix("QQ422842FA"){
            return Tencent.shared.openURL(url: url)
        }
        return true
    }

    
    
}

extension AppDelegate : UNUserNotificationCenterDelegate{
    
    // 注册远程推送通知
    func registerNotifications(_ application: UIApplication) {
            
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                
            }
        }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let device =  OCUtil.deviceToken(from: deviceToken)
        
        UserDefaults.standard.setValue(device, forKey: "deviceToken")
        
        UMessage.registerDeviceToken(deviceToken) //{length=32,bytes=0xfcf1c7b1ccfb07c9f1556151e5a87eb7...e77ac1798c3b5d56}
//        CBToast.showToastAction(message: device as NSString)
        NSSystemManager.manager.copyString(text: device)
        
    }
     // 上报deviceToken

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            
       // 弹窗提示
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let dict = response.notification.request.content.userInfo
        let request = response.notification.request
        let content = response.notification.request.content
        let badge = content.badge
        let body = content.body
        let sound = content.sound
        let subtittle = content.subtitle
        let title = content.title
        
        
        let json = JSON(dict)
         print("LogInfo=====\n \(json) \n===\(json["ivygateField1"]["id"])==")
        let ivyGateField = json["ivygateField1"].string
        let data =  ivyGateField!.data(using: .utf8, allowLossyConversion: false)
        
        
        print("respJsonData=\(data)")
        let decodedJsonDict = try! JSON(data: data!)
        print("decodedJsonDict=\(decodedJsonDict)")
        
        let id = decodedJsonDict["id"].intValue
        //tuisong
        let noticeDesVC = NoticeDescriptViewController()
        noticeDesVC.systemNoticeUserId = id
        if User.shared.token.count > 0 {
            NavigationController.shared.pushViewController(noticeDesVC, animated: false)
        }else {
            
        }
        
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            //ios10以上前台收到远程通知消息
            
        }else {
           //本地通知
            
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let dict = notification.request.content.userInfo
        let request = notification.request
        let content = notification.request.content
        let badge = content.badge
        let body = content.body
        let sound = content.sound
        let subtittle = content.subtitle
        let title = content.title
        
        //前台通知
        let json = JSON(dict)
                print("LogInfo=====\n \(json) \n===\(json["ivygateField1"]["id"])==")
               let ivyGateField = json["ivygateField1"].string
               let data =  ivyGateField!.data(using: .utf8, allowLossyConversion: false)
               print("respJsonData=\(data)")
               let decodedJsonDict = try! JSON(data: data!)
               print("decodedJsonDict=\(decodedJsonDict)")
        
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            //ios10以上前台收到远程通知消息
            
            print("LogInfo=====\n \(dict) \n=====")
            
        }else {
           //本地通知
            
        }
        
        completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.badge.rawValue|UNNotificationPresentationOptions.sound.rawValue|UNNotificationPresentationOptions.alert.rawValue))
    }

}

