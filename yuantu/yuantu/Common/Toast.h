//
//  Toast.h
//  bclient
//
//  Created by 季成 on 16/4/8.
//  Copyright © 2016年 季成. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSTimeInterval kToastDurationLong;
extern NSTimeInterval kToastDurationShort;

@interface Toast : UIView

- (void)show;
- (void)dismiss;
- (void)showWithDuration:(NSTimeInterval)duration animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

+ (Toast *)toastWithText:(NSString *)text;
+ (void)showToastWithText:(NSString *)text;

@end

@interface TextToast : Toast

- (id)initWithText:(NSString *)text;

@end
