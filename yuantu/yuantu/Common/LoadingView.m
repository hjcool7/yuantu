//
//  LoadingView.m
//  yuantu
//
//  Created by 季成 on 16/7/22.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "LoadingView.h"
#import "UIView+AutoLayout.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.hidden = YES;
        self.alpha = 0;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:indicator];
        [indicator setAlignParentCenter];
        [indicator startAnimating];
    }
    return self;
}

+ (instancetype)modalessLoadingView
{
    LoadingView *loadingView = [[LoadingView alloc] init];
    loadingView.userInteractionEnabled = NO;
    return loadingView;
}
+ (instancetype)modalLoadingView
{
    LoadingView *loadingView = [[LoadingView alloc] init];
    loadingView.userInteractionEnabled = YES;
    return loadingView;
}

- (void)showInView:(UIView *)parentView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addSubview:self];
    [self setEdgeConstraints:UIEdgeInsetsZero];
    
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^
     {
         self.alpha = 1;
     }];
    
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^
     {
         self.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         self.hidden = YES;
         [self removeFromSuperview];
     }];
}

@end
