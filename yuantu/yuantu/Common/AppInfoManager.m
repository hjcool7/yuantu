//
//  AppInfoManager.m
//  yuantu
//
//  Created by ayibang on 16/7/31.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "AppInfoManager.h"

@implementation AppInfoManager

+ (instancetype)sharedManager
{
    static AppInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppInfoManager alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.version = @"1.0";
        self.appStoreUrl = @"https://itunes.apple.com/us/app/yuan-tu/id1128271704?l=zh&ls=1&mt=8";
    }
    return self;
}

@end
