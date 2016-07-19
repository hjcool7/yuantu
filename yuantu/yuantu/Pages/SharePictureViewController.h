//
//  SharePictureViewController.h
//  yuantu
//
//  Created by ayibang on 16/7/18.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "PictureViewController.h"

@class Asset;

@interface SharePictureViewController : PictureViewController

@property (nonatomic,strong,readonly) Asset *asset;
@property (nonatomic,strong,readonly) UIImage *image;

- (id)initWithAsset:(Asset *)asset;
- (id)initWithImage:(UIImage *)image;

@end
