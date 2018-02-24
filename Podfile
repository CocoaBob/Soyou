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
    pod "DACircularProgress"
	pod "EAIntroView"
	pod "FCUUID"
    pod "Fingertips"
	pod "FlagKit", :git => 'git://github.com/choco/FlagKit', :branch => 'master'
	pod "OOPhotoBrowser", :git => 'git://github.com/CocoaBob/OOPhotoBrowser', :branch => 'master'
	pod "MagicalRecord", '~> 2.3'
	pod "MBProgressHUD"
	pod "MJRefresh"
	pod "MXParallaxHeader", :git => 'git://github.com/maxep/MXParallaxHeader', :branch => 'master'
	pod "NYSegmentedControl"
	pod "PageMenu", :git => 'git://github.com/JoeFerrucci/PageMenu', :branch => 'master'
	pod "PFCarouselView", :git => 'git://github.com/CocoaBob/PFCarouselView', :branch => 'master'
    pod "QRCode"
	pod "SDWebImage"
	pod "SMCalloutView", :git => 'git://github.com/CocoaBob/calloutview', :branch => 'master'
    pod "SnapKit", '~> 4.0.0'
	pod "SSZipArchive"
    pod "SwiftyJSON"
    pod "TLPhotoPicker", :git => 'git://github.com/CocoaBob/TLPhotoPicker', :branch => 'master'
	pod "UICKeyChainStore"
	pod "UIColor_Hex_Swift"
	pod "UIImage-ResizeMagick"
	pod "UIView+Shake"
    pod "ZFDragableModalTransition", :git => 'git://github.com/CocoaBob/ZFDragableModalTransition', :branch => 'master'
#    pod "PullToDismiss"
	pod "ZoomInteractiveTransition"
    
	#Continuous Integration
	pod "Fabric"
	pod "Crashlytics"

    #SNS SDKs
#    pod "DDThirdShareLibrary/TencentSDK" // Added manually
    pod "WechatOpenSDK"
    pod "WeiboSDK", '~> 3.1.3'
    pod "FBSDKLoginKit"
    pod "FBSDKShareKit"
    pod "TwitterKit", '~> 2'
    pod "TwitterCore", '~> 2'
    pod "Google/SignIn"
    
#    pod "Alamofire"
end

Swift4Targets = ['TLPhotoPicker', 'SnapKit']
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if Swift4Targets.include? target.name
                config.build_settings['SWIFT_VERSION'] = '4'
                else
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
