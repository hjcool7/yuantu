//
//  Asset.h
//  yuantu
//
//  Created by 季成 on 16/7/15.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface Asset : NSObject

@property (nonatomic,strong,readonly) PHAsset *asset;
@property (nonatomic,readonly) BOOL isOriginal;

@property (nonatomic,strong) NSNumber *isOriginalNumber;

- (id)initWithAsset:(PHAsset *)asset;

- (PHImageRequestID)requestImageForTargetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *result, NSDictionary *info))resultHandler;
- (PHImageRequestID)requestLargeImageForTargetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *result, NSDictionary *info))resultHandler;
- (void)requestIsOriginalWithResultHandler:(void(^)(Asset *asset,BOOL isOriginal))resultHandler;

//- (UIImage *)thumbnailImage;
//- (NSData *)imageData;
//- (NSData *)imageDataForWeixin;
//- (UIImage *)fullImage;

- (UIImage *)fullImage;

+ (BOOL)isCancelled:(NSDictionary *)info;
+ (void)cancelImageRequest:(PHImageRequestID)requestID;

@end
