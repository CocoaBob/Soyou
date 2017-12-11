source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
platform :ios, '10.0'
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
	pod "FlagKit", :git => 'git://github.com/choco/FlagKit', :branch => 'master'
	pod "OOPhotoBrowser"
	pod "MagicalRecord", '~> 2.3'
	pod "MBProgressHUD"
	pod "MJRefresh"
	pod "MXParallaxHeader", :git => 'git://github.com/maxep/MXParallaxHeader', :branch => 'master'
	pod "NYSegmentedControl"
	pod "PageMenu", :git => 'git://github.com/JoeFerrucci/PageMenu', :branch => 'master'
	pod "PFCarouselView", :git => 'git://github.com/CocoaBob/PFCarouselView', :branch => 'master'
	pod "SCLAlertView"
	pod "SDWebImage"
	pod "SMCalloutView", :git => 'git://github.com/CocoaBob/calloutview', :branch => 'master'
	pod "SSZipArchive"
    pod "SVWebViewController"
    pod "SwiftyJSON"
	pod "UICKeyChainStore"
	pod "UIColor_Hex_Swift"
	pod "UIImage-ResizeMagick"
	pod "UIView+Shake"
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
    pod "TwitterKit", '~> 2'
    pod "TwitterCore", '~> 2'
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
