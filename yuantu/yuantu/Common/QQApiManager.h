//
//  QQApiManager.h
//  yuantu
//
//  Created by 季成 on 16/7/21.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>

@class Asset;

@interface QQApiManager : NSObject<TencentSessionDelegate,QQApiInterfaceDelegate>

+ (instancetype)sharedManager;

- (void)registerApp;
- (BOOL)canShare;
- (void)shareWithAsset:(Asset *)asset;
- (void)shareWithMediaInfo:(NSDictionary *)mediaInfo;

@end
