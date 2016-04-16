//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

@import AddressBook;
@import Contacts;
@import CoreLocation;
@import Foundation;
@import MapKit;
@import MessageUI;
@import StoreKit;
@import UIKit;

// To get device info
#include <sys/utsname.h>

#import <1PasswordExtension/OnePasswordExtension.h>
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import <AFNetworking/AFNetworking.h>
#import <Base64nl/Base64.h>
#import <CCHMapClusterController/CCHCenterOfMassMapClusterer.h>
#import <CCHMapClusterController/CCHFadeInOutMapAnimator.h>
#import <CCHMapClusterController/CCHMapAnimator.h>
#import <CCHMapClusterController/CCHMapClusterAnnotation.h>
#import <CCHMapClusterController/CCHMapClusterController.h>
#import <CCHMapClusterController/CCHMapClusterControllerDelegate.h>
#import <CCHMapClusterController/CCHMapClusterer.h>
#import <CCHMapClusterController/CCHNearCenterMapClusterer.h>
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import <DDSocial/DDSocialAuthHandler.h>
#import <DDSocial/DDSocialShareHandler.h>
#import <DDSocial/WXApiObject.h>
#import <DDSocial/WXApi.h>
#import <EAIntroView/EAIntroView.h>
#import <FCUUID/FCUUID.h>
#import <FlagKit/UIImage+FlagKit.h>
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import <MagicalRecord/MagicalRecord.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import <MXParallaxHeader/MXParallaxHeader.h>
#import <NYSegmentedControl/NYSegmentedControl.h>
#import <PageMenu/CAPSPageMenu.h>
#import <PFCarouselView/PFCarouselView.h>
#import <SafariServices/SafariServices.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <SCLAlertView-Objective-C/SCLAlertViewResponder.h>
#import <SCLAlertView-Objective-C/SCLAlertViewStyleKit.h>
#import <SCLAlertView-Objective-C/SCLButton.h>
#import <SCLAlertView-Objective-C/SCLMacros.h>
#import <SCLAlertView-Objective-C/SCLSwitchView.h>
#import <SCLAlertView-Objective-C/SCLTextView.h>
#import <SCLAlertView-Objective-C/SCLTimerDisplay.h>
#import <SCLAlertView-Objective-C/UIImage+ImageEffects.h>
#import <SDWebImage/NSData+ImageContentType.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageCompat.h>
#import <SDWebImage/SDWebImageDecoder.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageDownloaderOperation.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDWebImageOperation.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import <SDWebImage/UIImageView+HighlightedWebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCacheOperation.h>
#import <SMCalloutView/SMCalloutView.h>
#import <SVWebViewController/SVWebViewController.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import <UIColor-HexRGB/UIColor+HexRGB.h>
#import <UIImage-ResizeMagick/UIImage+ResizeMagick.h>
#import <UIView+Shake/UIView+Shake.h>
#import <WTStatusBar/WTStatusBar.h>
#import <ZoomInteractiveTransition/ZoomInteractiveTransition.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

/*
@import OnePasswordExtension;
//@import Alamofire;
@import ActionSheetPicker_3_0;
@import AFNetworking;
@import Base64nl;
@import CCHMapClusterController;
@import CHTCollectionViewWaterfallLayout;
@import EAIntroView;
@import FCUUID;
//@import FlagKit;
@import IDMPhotoBrowser;
@import MagicalRecord;
@import MBProgressHUD;
@import MJRefresh;
@import MXParallaxHeader;
@import NYSegmentedControl;
//@import PageMenu;
@import PFCarouselView;
@import SafariServices;
@import SCLAlertView;
@import SDWebImage;
@import SMCalloutView;
@import SVWebViewController;
//@import SwiftyJSON;
@import UICKeyChainStore;
//@import UIColor_HexRGB;
@import UIImage_ResizeMagick;
@import UIView_Shake;
@import WTStatusBar;
@import ZoomInteractiveTransition;

// Continuous Integration
@import Fabric;
@import Crashlytics;

// SNS SDKs
// libWeChatSDK
//#import <libWeChatSDK/WXApiObject.h>
//#import <libWeChatSDK/WXApi.h>
// libWeiboSDK
//#import <WeiboSDK/WBHttpRequest.h>
//#import <WeiboSDK/WBHttpRequest+WeiboGame.h>
//#import <WeiboSDK/WBHttpRequest+WeiboShare.h>
//#import <WeiboSDK/WBHttpRequest+WeiboToken.h>
//#import <WeiboSDK/WBHttpRequest+WeiboUser.h>
//#import <WeiboSDK/WBSDKBasicButton.h>
//#import <WeiboSDK/WBSDKCommentButton.h>
//#import <WeiboSDK/WBSDKRelationshipButton.h>
//#import <WeiboSDK/WeiboSDK.h>
//#import <WeiboSDK/WeiboUser.h>
// QQOpenSDK
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/QQApiInterfaceObject.h>
//#import <TencentOpenAPI/sdkdef.h>
//#import <TencentOpenAPI/TencentApiInterface.h>
//#import <TencentOpenAPI/TencentMessageObject.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/TencentOAuthObject.h>
// LXMThirdLoginManager
//@import LXMThirdLoginManager;
*/