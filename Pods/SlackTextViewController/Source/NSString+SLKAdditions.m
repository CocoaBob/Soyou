//
//  NSString+SLKAdditions.m
//  SlackTextViewController
//
//  Created by CocoaBob on 2018-04-15.
//  Copyright © 2018 Slack Technologies, Inc. All rights reserved.
//

#import "NSString+SLKAdditions.h"
#import "SLKTextViewController.h"

@implementation NSString (SLKAdditions)

- (NSString *)SLKLocalized {
    NSURL *url = [[NSBundle bundleForClass:[SLKTextViewController class]] URLForResource:@"SlackTextViewController" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    if (bundle) {
        return [bundle localizedStringForKey:self value:self table:nil];
    } else {
        return self;
    }
}

@end
