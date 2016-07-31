//
//  QRCodeUtil.h
//  yuantu
//
//  Created by ayibang on 16/7/31.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeUtil : NSObject

+ (UIImage *)qrCodeImageWithString:(NSString *)string size:(CGFloat)size;

@end
