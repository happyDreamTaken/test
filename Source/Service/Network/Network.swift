//
//  Network.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/13.
//  Copyright © 2019 yicheng. All rights reserved.
//

import Foundation
import Reachability

class Network: NSObject {
    
    static let shared = Network()
    
    var connection:Reachability.Connection?
    
    private var _reachability = Reachability()
    
    /// 开始监听
    func start(){
        if let reachability = _reachability {
            do {
                try reachability.startNotifier()
                reachability.whenReachable = { [weak self] (r) in
                    self?.internetReachable(r)
                }
                reachability.whenUnreachable = { [weak self] (r) in
                    self?.internetUnreachable(r)
                }
            } catch {
                Log.Error("Unable to start reachability notifier")
            }
        }
    }
    
    /// 停止监听
    func stop(){
        _reachability?.stopNotifier()
    }
    
    /// 网络连接可用时优先调用，再发送通知
    ///
    /// - Parameter reachability: Reachability instance
    func internetReachable(_ reachability:Reachability){
        self.connection = reachability.connection
        Log.Info("网络已连接,连接方式:\(connection?.description ?? "未知错误" )")
        HomeViewController.shared.networkStatusChanged(isUsable)
    }
    
    /// 网络连接不可用时优先调用，再发送通知
    ///
    /// - Parameter reachability: Reachability instance
    func internetUnreachable(_ reachability:Reachability){
        self.connection = reachability.connection
        Log.Info("当前网络不可用,请检查网络设置")
        HomeViewController.shared.networkStatusChanged(isUsable)
    }
    
    /// 服务是否可用，目前与isReachable等同
    var isUsable:Bool {
        return isReachable
    }
    
    /// 网络是否可连接
    var isReachable:Bool {
        if self.connection == nil || self.connection == .none {
            return false
        }
        return true
    }
    
    
}
