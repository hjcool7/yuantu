//
//  Asset.m
//  yuantu
//
//  Created by 季成 on 16/7/15.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "Asset.h"

@interface Asset()

@property (nonatomic,strong,readwrite) PHAsset *asset;
@property (nonatomic,readwrite) BOOL isOriginal;

@end

@implementation Asset
{
    BOOL _hasReadMetadata;
}

- (id)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self)
    {
        self.asset = asset;
//        self.isOriginal = [self isPureImageWithAsset:self.asset];
        _hasReadMetadata = NO;
        self.isOriginal = YES;
        
    }
    return self;
}

- (BOOL)isOriginal
{
    if (!_hasReadMetadata)
    {
        self.isOriginal = [self isPureImageWithAsset:self.asset];
        _hasReadMetadata = YES;
    }
    return _isOriginal;
}

- (BOOL)isPureImageWithAsset:(PHAsset *)asset
{
    return [self isPureImage:[self assetMetaData:asset]];
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

- (PHImageRequestID)requestImageForTargetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *result, NSDictionary *info))resultHandler
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionOriginal;
    CGSize size;
    size.width = targetSize.width * [UIScreen mainScreen].scale;
    size.height = targetSize.height * [UIScreen mainScreen].scale;
    PHImageRequestID requestId = [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:resultHandler];
    return requestId;
}

- (PHImageRequestID)requestLargeImageForTargetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *result, NSDictionary *info))resultHandler
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionOriginal;
    CGSize size;
    size.width = targetSize.width * [UIScreen mainScreen].scale;
    size.height = targetSize.height * [UIScreen mainScreen].scale;
    PHImageRequestID requestId = [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:resultHandler];
    return requestId;
}

+ (BOOL)isCancelled:(NSDictionary *)info
{
    return [[info objectForKey:PHImageCancelledKey] boolValue];
}

+ (void)cancelImageRequest:(PHImageRequestID)requestID
{
    [[PHImageManager defaultManager] cancelImageRequest:requestID];
}

@end
