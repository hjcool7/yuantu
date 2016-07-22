//
//  WXApiManager.h
//  yuantu
//
//  Created by 季成 on 16/7/21.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@class Asset;

@interface WXApiManager : NSObject<WXApiDelegate>

+ (instancetype)sharedManager;

- (void)registerApp;
- (BOOL)canShare;
- (void)shareWithAsset:(Asset *)asset scene:(int)scene;
- (void)shareWithMediaInfo:(NSDictionary *)mediaInfo scene:(int)scene;

@end
