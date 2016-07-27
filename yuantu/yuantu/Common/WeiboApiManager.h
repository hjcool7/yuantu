//
//  WeiboApiManager.h
//  yuantu
//
//  Created by ayibang on 16/7/27.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@class Asset;

@interface WeiboApiManager : NSObject<WeiboSDKDelegate>

+ (instancetype)sharedManager;

- (void)registerApp;
- (BOOL)canShare;
- (void)shareWithAsset:(Asset *)asset;
- (void)shareWithMediaInfo:(NSDictionary *)mediaInfo;

@end
