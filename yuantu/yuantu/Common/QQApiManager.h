//
//  QQApiManager.h
//  yuantu
//
//  Created by ayibang on 16/7/21.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

@class Asset;

@interface QQApiManager : NSObject<TencentSessionDelegate>

+ (instancetype)sharedManager;

- (void)registerApp;
- (void)shareWithAsset:(Asset *)asset;
- (void)shareWithMediaInfo:(NSDictionary *)mediaInfo;

@end
