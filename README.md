# 常青藤之门

#### 介绍
{**以下是码云平台说明，您可以替换此简介**
码云是 OSCHINA 推出的基于 Git 的代码托管平台（同时支持 SVN）。专为开发者提供稳定、高效、安全的云端软件开发协作平台
无论是个人、团队、或是企业，都能够用码云实现代码托管、项目管理、协作开发。企业项目请看 [https://gitee.com/enterprises](https://gitee.com/enterprises)}

## 常春藤技术说明
###  本工程依赖框架
  1.  Alrdframework
      alrdframework是一个以go语言为基础的动态库，目前支持arm64，arm7s架构（不支持x86和arm7）
  2.  PacketProcessor
        内置于项目内部的一个单独的Target，不以framework的形式提供（如需要，可自行打包成framework集成到项目中）
        
### VPN实现总体逻辑       
    Vpn启动方案--->VpnManager相关设置
    packetTunnel处理--->具体流量逻辑处理

### 常春藤IOS版VPN相关设置

1. 配置
   把Alrdframework添加到PacketTunnel的Target中，并根据模版启动Alrd服务（传入参数时具体可参考方法startgoProxy）
   
    PacketProccessor的target主要提供了tun2socks的数据转发处理。在集成过程中需要在当前target下的build setting具体处理两个方面
       1，相关c文件路径设置 （build setting -> search
       path -> framework search path）
       2, 自定义的宏 （Preporcessor Macros 添加相关宏）
       
       /**
       * 方法二
       * 单独摘出Processor的target当作独立工程编译，并 
       * 把生成的支持真机版本的framework拖入到PackettunnelTarget中以供使用
       */
       
2. 详细设置
       如果集成了Alrdframework，和Processor的target并且没有报错则可进行具体的业务逻辑
       
       override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
          
          1,获取vpn启动时传入的vpn的相关b配置信息
          2，设置NEPacketTunnelNetworkSettings
          3，异步启动Alrd（startgoProxy）
         setTunnelNetworkSettings(networkSettings) { error in
                  guard error == nil else {
                      completionHandler(error)
                      return
                  }
             //启动tun2socks并开始读取
                 self.startTun2socks()
                 self.beginRead()
          
                  completionHandler(nil)
                 
              }
       }

