//
//  PictureManager.m
//  yuantu
//
//  Created by ayibang on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "PictureManager.h"
#import "Asset.h"
#import "AssetCollection.h"

NSString *const PictureManagerChangeNotification = @"PictureManagerChangeNotification";

@interface PictureManager()<PHPhotoLibraryChangeObserver>

@property (nonatomic,copy,readwrite) NSArray<Asset *> *allPictures;
@property (nonatomic,copy,readwrite) NSArray<AssetCollection *> *allAlbums;

@end

@implementation PictureManager

+ (instancetype)sharedManager
{
    static PictureManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PictureManager alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    return self;
}

- (BOOL)authorized
{
    return ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized);
}

- (void)fetchAllAlbumsWithCompletion:(void(^)(NSArray<AssetCollection *> *allAlbums))completion
{
    self.allAlbums = nil;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
     {
         if ([self authorized])
         {
             dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                           {
                               PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
                               NSMutableArray *albums = [[NSMutableArray alloc] init];
                               for (PHAssetCollection *assetCollection in result)
                               {
                                   if (![assetCollection isKindOfClass:[PHAssetCollection class]])
                                   {
                                       continue;
                                   }
                                   AssetCollection *collection = [[AssetCollection alloc] initWithAssetCollection:assetCollection];
                                   if (collection.count > 0)
                                   {
                                       [albums addObject:collection];
                                   }
                               }
                               self.allAlbums = albums;
                           });
         }
         if (completion)
         {
             dispatch_async(dispatch_get_main_queue(), ^{completion(self.allAlbums);});
         }
     }];

}

- (void)fetchAllPicturesWithCompletion:(void(^)(NSArray<Asset *> *allPictures))completion
{
    self.allPictures = nil;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
     {
         if ([self authorized])
         {
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
            {
                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
                NSMutableArray *assets = [[NSMutableArray alloc] init];
                for (PHAsset *phAsset in result)
                {
                    if (![phAsset isKindOfClass:[PHAsset class]])
                    {
                        continue;
                    }
                    [assets addObject:[[Asset alloc] initWithAsset:phAsset]];
                }
                self.allPictures = assets;
            });
         }
         if (completion)
         {
             dispatch_async(dispatch_get_main_queue(), ^{completion(self.allPictures);});
         }
     }];
}

- (void)postChangeNotification
{
    dispatch_async(dispatch_get_main_queue(), ^
                  {
                      [[NSNotificationCenter defaultCenter] postNotificationName:PictureManagerChangeNotification object:nil];
                  });
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    [self postChangeNotification];
}

@end
