//
//  PictureManager.h
//  yuantu
//
//  Created by ayibang on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PHAsset(PictureManager)

@property (nonatomic) BOOL isOriginal;

@end

extern NSString *const PictureManagerChangeNotification;

@interface PictureManager : NSObject

@property (nonatomic,copy,readonly) NSArray<PHAsset *> *allPictures;

+ (instancetype)sharedManager;

- (void)fetchAllPictures;
- (BOOL)authorized;

@end
