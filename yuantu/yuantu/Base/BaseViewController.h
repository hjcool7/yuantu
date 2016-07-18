//
//  BaseViewController.h
//  yuantu
//
//  Created by 季成 on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,strong) UIImage *leftNavButtonImage;
@property (nonatomic,strong) UIImage *rightNavButtonImage;

- (void)leftNavButtonClicked:(id)sender;
- (void)rightNavButtonClicked:(id)sender;

@end
