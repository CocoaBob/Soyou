#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "IDMBrowserDelegate.h"
#import "IDMCaptionView.h"
#import "IDMPBConstants.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "IDMPhotoDataSource.h"
#import "IDMPhotoProtocol.h"
#import "IDMTapDetectingImageView.h"
#import "IDMTapDetectingView.h"
#import "IDMUtils.h"
#import "IDMZoomingScrollView.h"

FOUNDATION_EXPORT double OOPhotoBrowserVersionNumber;
FOUNDATION_EXPORT const unsigned char OOPhotoBrowserVersionString[];

