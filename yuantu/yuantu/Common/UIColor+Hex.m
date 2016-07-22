//
//  UIColor+Creation.m
//  bclient
//
//  Created by 季成 on 16/4/6.
//  Copyright © 2016年 季成. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Creation)

+ (UIColor *)hex_colorWithHex:(uint)hex
{
    int red, green, blue, alpha;
    
    if (hex > 0xffffff) {
        return [UIColor hex_colorWithARGBHex:hex];
    }
    
    blue = hex & 0x0000FF;
    green = ((hex & 0x00FF00) >> 8);
    red = ((hex & 0xFF0000) >> 16);
    alpha = 1;
    
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha];
}

+ (UIColor *)hex_colorWithARGBHex:(uint)hex
{
    int red, green, blue, alpha;
    
    blue = hex & 0x000000FF;
    green = ((hex & 0x0000FF00) >> 8);
    red = ((hex & 0x00FF0000) >> 16);
    alpha = ((hex & 0xFF000000) >> 24);
    
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha/255.f];
}

+ (UIColor *)hex_colorWithString:(NSString *)hexString
{
    NSUInteger length = hexString.length;
    if (length == 6 || length == 7)
    {
        return [self hex_colorWithHexString:hexString];
    }
    else if (length == 8 || length == 9)
    {
        return [self hex_colorWithARGBHexString:hexString];
    }
    return nil;
}

+ (UIColor *)hex_colorWithHexString:(NSString *)hexString
{
    if ([hexString hasPrefix:@"#"])
    {
        hexString = [hexString substringFromIndex:1];
    }
    
    if ([hexString length] != 6)
    {
        return nil;
    }
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(CGFloat)(red / 255.0) green:(CGFloat)(green / 255.0) blue:(CGFloat)(blue / 255.0) alpha:1.0];
}

+ (UIColor *)hex_colorWithARGBHexString:(NSString *)hexString
{
    if ([hexString hasPrefix:@"#"])
    {
        hexString = [hexString substringFromIndex:1];
    }
    
    if ([hexString length] != 8)
    {
        return nil;
    }
    
    unsigned int alpha,red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&alpha];
    range.location = 2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    range.location = 4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    range.location = 6;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(CGFloat)(red / 255.0) green:(CGFloat)(green / 255.0) blue:(CGFloat)(blue / 255.0) alpha:(CGFloat)(alpha / 255.0)];
}

+ (UIColor *)getColor:(NSString *)hexColor addAlpha:(float)alpha {
    NSString *colorString = [hexColor copy];
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    
    if ([colorString length]!=6) return nil;
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha];
    
}

@end
