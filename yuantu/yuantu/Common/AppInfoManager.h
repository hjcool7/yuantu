//
//  AppInfoManager.h
//  yuantu
//
//  Created by ayibang on 16/7/31.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfoManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic,copy) NSString *version;
@property (nonatomic,copy) NSString *appStoreUrl;

@end
