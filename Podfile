source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
platform :ios, '8.0'
project "Soyou"

inhibit_all_warnings!

target :'Soyou' do
	pod "1PasswordExtension"
	pod "ActionSheetPicker-3.0"
	pod "AFNetworking", '~> 2'
	pod "Base64nl"
	pod "CCHMapClusterController"
	pod "CHTCollectionViewWaterfallLayout"
	pod "EAIntroView"
	pod "FCUUID"
	pod "FlagKit", :git => 'git://github.com/gastonkosut/FlagKit', :commit => '3a337be5f5458c91b5d7dfb4b735ec8a77c444ab'
	pod "IDMPhotoBrowser"
	pod "MagicalRecord", '~> 2.3'
	pod "MBProgressHUD"
	pod "MJRefresh"
	pod "MXParallaxHeader", :git => 'git://github.com/developforapple/MXParallaxHeader', :commit => '1491e2b86b1112a560f2dc78b3437299293ef60e'
	pod "NYSegmentedControl"
	pod "PageMenu", :git => 'git://github.com/JoeFerrucci/PageMenu', :commit => '3477a47af6d01480c98f4095959e4a5d1e91a841'
	pod "PFCarouselView", :git => 'git://github.com/CocoaBob/PFCarouselView', :commit => '880826c7f361c3065ca23a4696a4d19d7e1da6d3'
	pod "SCLAlertView"
	pod "SDWebImage"
	pod "SMCalloutView", :git => 'git://github.com/CocoaBob/calloutview', :commit => 'bad0864b06019d764519dab9a53409de889c87fc'
	pod "SSZipArchive"
    pod "SVWebViewController"
    pod "SwiftyJSON"
	pod "UICKeyChainStore"
	pod "UIColor_Hex_Swift"
	pod "UIImage-ResizeMagick"
	pod "UIView+Shake"
    #pod "WTStatusBar", :git => 'git://github.com/CocoaBob/WTStatusBar', :commit => '42bd2739315f1a24e3e1bf96e8d30a0430bf51b9'
	pod "ZoomInteractiveTransition"

	#Continuous Integration
	pod "Fabric"
	pod "Crashlytics"

    #SNS SDKs
    pod "DDThirdShareLibrary/TencentSDK"
    pod "libWeChatSDK"
    pod "WeiboSDK", '~> 3.1.3'
    pod "FBSDKLoginKit"
    pod "FBSDKShareKit"
    pod "TwitterKit",'~> 2'
    pod "Google/SignIn"
    
#    pod "Alamofire"
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
