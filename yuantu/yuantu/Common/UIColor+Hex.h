//
//  UIColor+Creation.h
//  bclient
//
//  Created by 季成 on 16/4/6.
//  Copyright © 2016年 季成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hex)

+ (UIColor *)hex_colorWithHex:(uint)hex;
+ (UIColor *)hex_colorWithARGBHex:(uint)hex;
+ (UIColor *)hex_colorWithString:(NSString *)hexString;
+ (UIColor *)hex_colorWithHexString:(NSString *)hexString;
+ (UIColor *)hex_colorWithARGBHexString:(NSString *)hexString;

@end
