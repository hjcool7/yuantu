//
//  LoadingView.h
//  yuantu
//
//  Created by 季成 on 16/7/22.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (instancetype)modalessLoadingView;
+ (instancetype)modalLoadingView;
- (void)showInView:(UIView *)parentView;
- (void)dismiss;

@end
