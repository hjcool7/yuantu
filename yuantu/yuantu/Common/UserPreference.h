//
//  UserPreference.h
//  bclient
//
//  Created by ayibang on 16/4/12.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreference : NSObject

+ (instancetype)sharedPreference;

@property (nonatomic,copy) NSString *currentVersion;

@end
