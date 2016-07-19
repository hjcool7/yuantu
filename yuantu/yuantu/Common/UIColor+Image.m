//
//  UIColor+Image.m
//  bclient
//
//  Created by ayibang on 16/4/6.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "UIColor+Image.h"

@implementation UIColor (Image)

- (UIImage *)img_colorImage
{
    return [self img_colorImageWithSize:CGSizeMake(1, 1)];
}

- (UIImage *)img_colorImageWithSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
