source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

target :'IvyGate' do
    pod 'SnapKit'
    pod 'SwiftyJSON'
    pod 'Kingfisher'
    pod 'SwiftyStoreKit'
    pod 'Alamofire'
    pod 'SwiftGifOrigin', '~> 1.7.0'
    pod 'ReachabilitySwift'
    pod 'MagazineLayout'
    pod 'UMCAnalytics'
    pod 'MJRefresh'
    pod 'WechatOpenSDK'
    pod 'UMCPush'
    pod 'UMCSecurityPlugins'
    pod 'UMCCommon', '~> 2.1.1'
    pod 'CLImagePickerTool'
    pod 'CryptoSwift', '~> 1.0'
    pod 'HandyJSON', '~> 5.0.0-beta.1'
end

post_install do |installer|
    
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
