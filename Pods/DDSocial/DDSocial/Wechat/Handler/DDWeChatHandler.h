//
//  DDWeChatHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialHandlerProtocol.h"

@interface DDWeChatHandler : NSObject

@end

@interface DDWeChatHandler (DDSocialHandlerProtocol) <DDSocialHandlerProtocol>

@end

