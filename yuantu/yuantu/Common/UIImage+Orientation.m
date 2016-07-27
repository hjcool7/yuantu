//
//  UIImage+Orientation.m
//  yuantu
//
//  Created by 季成 on 16/7/19.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "UIImage+Orientation.h"
#import "GPUImagePicture.h"
#import "GPUImageGrayscaleFilter.h"

@implementation UIImage (Orientation)

- (void)grayscaleImageWithResultHandler:(void(^)(UIImage *original,UIImage *gray))resultHandler
{
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^
                   {
                       GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self];
                       GPUImageGrayscaleFilter *stillImageFilter = [[GPUImageGrayscaleFilter alloc] init];
                       
                       [stillImageSource addTarget:stillImageFilter];
                       [stillImageFilter useNextFrameForImageCapture];
                       [stillImageSource processImage];
                       
                       UIImage *gray = [stillImageFilter imageFromCurrentFramebuffer];
                       if (resultHandler)
                       {
                           resultHandler(self,gray);
                       }
                   });
}

- (UIImage *) grayscaleImage
{
//    CGSize size = self.size;
//    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width,
//                             self.size.height);
//    // Create a mono/gray color space
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    CGContextRef context = CGBitmapContextCreate(nil, size.width,
//                                                 size.height, 8, 0, colorSpace, kCGImageAlphaNone);
//    CGColorSpaceRelease(colorSpace);
//    // Draw the image into the grayscale context
//    CGContextDrawImage(context, rect, [self CGImage]);
//    CGImageRef grayscale = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    // Recover the image
//    UIImage *img = [UIImage imageWithCGImage:grayscale];
//    CFRelease(grayscale);
//    return img;
    
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self];
    GPUImageGrayscaleFilter *stillImageFilter = [[GPUImageGrayscaleFilter alloc] init];
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    return [stillImageFilter imageFromCurrentFramebuffer];
}

- (UIImage *)thumbnailImage
{
    CGSize size = CGSizeMake(self.size.width, self.size.height);
    if (size.width > size.height)
    {
        size.height = ceil(size.height / size.width * 50);
        size.width = 50;
    }
    else
    {
        size.width = ceil(size.width / size.height * 50);
        size.height = 50;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)fixedOrientationImage
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
