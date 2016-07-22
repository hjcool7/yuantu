//
//  ShowPictureViewController.h
//  yuantu
//
//  Created by 季成 on 16/7/18.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "PictureViewController.h"

@class Asset;

@interface ShowPictureViewController : PictureViewController

@property (nonatomic,copy,readonly) NSArray<Asset *> *assets;
@property (nonatomic,readonly) NSInteger index;

- (id)initWithAssets:(NSArray<Asset *> *)assets index:(NSInteger)index;

@end
