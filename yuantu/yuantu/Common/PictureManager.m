//
//  PictureManager.m
//  yuantu
//
//  Created by ayibang on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "PictureManager.h"
#import <objc/runtime.h>

NSString *const PictureManagerChangeNotification = @"PictureManagerChangeNotification";

static const char * kPHAssetIsOriginalKey;

@implementation PHAsset(PictureManager)

- (void)setIsOriginal:(BOOL)isOriginal
{
    objc_setAssociatedObject(self, &kPHAssetIsOriginalKey, @(isOriginal), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isOriginal
{
    return [objc_getAssociatedObject(self, &kPHAssetIsOriginalKey) boolValue];
}

@end

@interface PictureManager()<PHPhotoLibraryChangeObserver>

@property (nonatomic,copy,readwrite) NSArray<PHAsset *> *allPictures;

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

- (void)fetchAllPictures
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
                for (PHAsset *asset in result)
                {
                    if (![asset isKindOfClass:[PHAsset class]])
                    {
                        continue;
                    }
                    asset.isOriginal = [self isPureImage:[self assetMetaData:asset]];
                    [assets addObject:asset];
                }
                self.allPictures = assets;
            });
         }
        [self postChangeNotification];
     }];
}

- (BOOL)isPureImage:(NSDictionary*)exifDic
{
    return ([exifDic valueForKey:@"{MakerApple}"] != nil);
}

- (NSDictionary *)metadataFromImageData:(NSData*)imageData
{
    NSDictionary *metadata = nil;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)(imageData), NULL);
    if (imageSource)
    {
        NSDictionary *options = @{(NSString *)kCGImageSourceShouldCache : [NSNumber numberWithBool:NO]};
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0,  (CFDictionaryRef)options);
        if (imageProperties)
        {
            metadata = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)imageProperties];
            CFRelease(imageProperties);
        }
        CFRelease(imageSource);
    }
    
    return metadata;
}

- (NSDictionary *)assetMetaData:(PHAsset*)asset
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    __block NSDictionary *metadataDic = nil;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
     {
         metadataDic = [self metadataFromImageData:imageData];
    }];
    return metadataDic;
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
