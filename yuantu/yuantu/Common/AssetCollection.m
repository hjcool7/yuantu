//
//  AssetCollection.m
//  yuantu
//
//  Created by 季成 on 16/7/15.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "AssetCollection.h"
#import "Asset.h"

@interface AssetCollection()

@property (nonatomic,strong,readwrite) PHAssetCollection *assetCollection;
@property (nonatomic,copy,readwrite) NSString *title;
@property (nonatomic,readwrite) NSInteger count;
@property (nonatomic,copy,readwrite) NSArray<Asset *> *assets;

@end

@implementation AssetCollection

- (id)initWithAssetCollection:(PHAssetCollection *)assetCollection
{
    self = [super init];
    if (self)
    {
        self.assetCollection = assetCollection;
        self.title = assetCollection.localizedTitle;
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES]];
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        for (PHAsset *phAsset in result)
        {
            if (![phAsset isKindOfClass:[PHAsset class]])
            {
                continue;
            }
            if (phAsset.mediaType != PHAssetMediaTypeImage)
            {
                continue;
            }
            
            Asset *asset = [[Asset alloc] initWithAsset:phAsset];
            [assets addObject:asset];
        }
        self.assets = assets;
        self.count = self.assets.count;
    }
    return self;
}

@end
