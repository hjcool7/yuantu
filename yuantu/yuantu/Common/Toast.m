//
//  Toast.m
//  bclient
//
//  Created by ayibang on 16/4/8.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "Toast.h"
#import "UIColor+Hex.h"
#import "UIView+Layout.h"

NSTimeInterval kToastDurationLong = 3.f;
NSTimeInterval kToastDurationShort = 1.5f;

@implementation Toast

- (void)show
{
    [self showWithDuration:kToastDurationShort animated:YES];
}
- (void)dismiss
{
    [self dismissAnimated:YES];
}

- (void)showWithDuration:(NSTimeInterval)duration animated:(BOOL)animated
{
    if (self.superview)
    {
        return;
    }
    
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([view isKindOfClass:[Toast class]])
        {
            Toast *lastToast = (Toast *)view;
            [lastToast dismissAnimated:NO];
        }
    }
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (animated)
    {
        [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:
         ^{
             self.alpha = 1;
         }
                         completion:^(BOOL finished)
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(),^
                            {
                                [self dismissAnimated:YES];
                            });
         }
         ];
    }
    else
    {
        self.alpha = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(),^
                       {
                           [self dismissAnimated:YES];
                       });
    }
}
- (void)dismissAnimated:(BOOL)animated
{
    if (!self.superview)
    {
        return;
    }
    if (animated)
    {
        [UIView animateWithDuration:.4f animations:^
         {
             self.alpha = 0;
         }
        completion:^(BOOL finished)
         {
             [self removeFromSuperview];
         }];
    }
    else
    {
        self.alpha = 0;
        [self removeFromSuperview];
    }
}

+ (Toast *)toastWithText:(NSString *)text
{
    return [[TextToast alloc] initWithText:text];
}
+ (void)showToastWithText:(NSString *)text
{
    [[self toastWithText:text] show];
}

@end

static const UIEdgeInsets kTextToastTextEdge = {10,10,10,10};
static const CGFloat kTextToastMaxWidth = 260;
static const CGFloat kTextToastMinWidth = 180;

@implementation TextToast

- (id)initWithText:(NSString *)text
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.backgroundColor = [UIColor hex_colorWithARGBHex:0xB2000000];
        self.userInteractionEnabled = NO;
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.preferredMaxLayoutWidth = kTextToastMaxWidth - kTextToastTextEdge.left - kTextToastTextEdge.right;
        textLabel.text = text;
        [self addSubview:textLabel];
        textLabel.width = kTextToastMaxWidth - kTextToastTextEdge.left - kTextToastTextEdge.right;
        [textLabel sizeToFit];
        
        CGFloat width = textLabel.width + kTextToastTextEdge.left + kTextToastTextEdge.right;
        width = (width < kTextToastMinWidth) ? kTextToastMinWidth : width;
        CGFloat height = textLabel.height + kTextToastTextEdge.top + kTextToastTextEdge.bottom;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        self.frame = CGRectMake((screenSize.width - width) / 2, screenSize.height - 100 - height / 2, width, height);
        textLabel.frame = CGRectMake((self.width - textLabel.width ) / 2, (self.height - textLabel.height) / 2, textLabel.width, textLabel.height);

    }
    return self;
}

@end
