//
//  Asset.m
//  yuantu
//
//  Created by 季成 on 16/7/15.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "Asset.h"
#import "PictureManager.h"
#import "UIImage+Orientation.h"

@interface Asset()

@property (nonatomic,strong,readwrite) PHAsset *asset;

@end

@implementation Asset
{
    NSMutableArray *_resultHandlers;
}

- (id)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self)
    {
        self.asset = asset;
        _resultHandlers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)isOriginal
{
    if (!self.isOriginalNumber)
    {
        self.isOriginalNumber = @([self isPureImageWithAsset:self.asset]);
    }
    return self.isOriginalNumber.boolValue;
}

- (void)requestIsOriginalWithResultHandler:(void(^)(Asset *asset,BOOL isOriginal))resultHandler
{
    if (self.isOriginalNumber)
    {
        if (resultHandler)
        {
            resultHandler(self,self.isOriginalNumber.boolValue);
        }
        return;
    }
    
    if (_resultHandlers.count > 0)
    {
        [_resultHandlers addObject:resultHandler];
        return;
    }
    
    [_resultHandlers addObject:resultHandler];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
     {
         if ([Asset isCancelled:info])
         {
             return;
         }
         dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^
                        {
                            NSDictionary *metadataDic = [self metadataFromImageData:imageData];
                            BOOL isOriginal = [self isPureImage:metadataDic];
                            dispatch_async(dispatch_get_main_queue(), ^
                                           {
                                               self.isOriginalNumber = @(isOriginal);
                                               for (void(^handler)(Asset *,BOOL) in _resultHandlers)
                                               {
                                                   if (handler)
                                                   {
                                                       handler(self,isOriginal);
                                                   }
                                               }
                                               [_resultHandlers removeAllObjects];
                                           });
                        });
     }];
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

- (UIImage *)fullImage
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.version = PHImageRequestOptionsVersionOriginal;
    __block UIImage *image = nil;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info)
     {
         BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
         if (downloadFinined)
         {
             image = result;
         }
     }];
    return image;
}

- (NSData *)imageDataForWeixin
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.version = PHImageRequestOptionsVersionOriginal;
    __block UIImage *image = nil;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(1080, 1920) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info)
     {
         BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
         if (downloadFinined)
         {
             image = result;
         }
     }];
    return UIImageJPEGRepresentation(image.weixinShareImage,1);
}

- (NSData *)imageData
{
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    options.synchronous = YES;
//    __block NSData *data = nil;
//    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
//     {
//         data = imageData;
//     }];
//    return data;

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.version = PHImageRequestOptionsVersionOriginal;
    __block UIImage *image = nil;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info)
     {
         BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
         if (downloadFinined)
         {
             image = result;
         }
     }];
    return UIImageJPEGRepresentation(image,1);
}

- (UIImage *)thumbnailImage
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.version = PHImageRequestOptionsVersionOriginal;
//    CGSize size = CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight);
//    if (size.width > size.height)
//    {
//        size.height = ceil(size.height / size.width * 90);
//        size.width = 90;
//    }
//    else
//    {
//        size.width = ceil(size.width / size.height * 90);
//        size.height = 90;
//    }
    __block UIImage *image = nil;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(1080, 1920) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info)
    {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (downloadFinined)
        {
            image = result;
        }
    }];
    return image.thumbnailImage;
}

- (PHImageRequestID)requestImageForTargetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *result, NSDictionary *info))resultHandler
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionOriginal;
    CGSize size;
    size.width = targetSize.width * [UIScreen mainScreen].scale;
    size.height = targetSize.height * [UIScreen mainScreen].scale;
    PHImageRequestID requestId = [[PictureManager sharedManager].imageManager requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:resultHandler];
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
