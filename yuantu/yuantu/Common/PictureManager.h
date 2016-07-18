//
//  PictureManager.h
//  yuantu
//
//  Created by 季成 on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@class Asset;
@class AssetCollection;

extern NSString *const PictureManagerChangeNotification;

@interface PictureManager : NSObject

@property (nonatomic,copy,readonly) NSArray<Asset *> *allPictures;
@property (nonatomic,copy,readonly) NSArray<AssetCollection *> *allAlbums;

+ (instancetype)sharedManager;

- (void)fetchAllPicturesWithCompletion:(void(^)(NSArray<Asset *> *allPictures))completion;
- (void)fetchAllAlbumsWithCompletion:(void(^)(NSArray<AssetCollection *> *allAlbums))completion;
- (BOOL)authorized;

@end
