//
//  UIImage+Orientation.h
//  yuantu
//
//  Created by 季成 on 16/7/19.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

- (UIImage *)fixedOrientationImage;
- (UIImage *)thumbnailImage;
- (UIImage *)shareImage;
//- (UIImage *)weixinShareImage;
- (UIImage *)grayscaleImage;
- (void)grayscaleImageWithResultHandler:(void(^)(UIImage *original,UIImage *gray))resultHandler;

- (NSData *)imageData;

@end
