//
//  AssetCollection.h
//  yuantu
//
//  Created by 季成 on 16/7/15.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@class Asset;

@interface AssetCollection : NSObject

@property (nonatomic,strong,readonly) PHAssetCollection *assetCollection;
@property (nonatomic,copy,readonly) NSString *title;
@property (nonatomic,readonly) NSInteger count;
@property (nonatomic,copy,readonly) NSArray<Asset *> *assets;

- (id)initWithAssetCollection:(PHAssetCollection *)assetCollection;

@end
