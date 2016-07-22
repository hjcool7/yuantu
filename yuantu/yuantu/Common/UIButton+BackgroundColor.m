//
//  UIButton+BackgroundColor.m
//  bclient
//
//  Created by 季成 on 16/4/6.
//  Copyright © 2016年 季成. All rights reserved.
//

#import "UIButton+BackgroundColor.h"
#import "UIColor+Image.h"

@implementation UIButton (BackgroundColor)

- (void)bg_setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    [self setBackgroundImage:[color img_colorImage] forState:state];
}

@end
