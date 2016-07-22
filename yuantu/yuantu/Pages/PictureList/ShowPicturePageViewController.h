//
//  ShowPicturePageViewController.h
//  yuantu
//
//  Created by 季成 on 16/7/18.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "BaseViewController.h"

@class Asset;

@interface ShowPicturePageViewController : BaseViewController

@property (nonatomic,strong,readonly) Asset *asset;
@property (nonatomic,readonly) NSInteger index;

- (id)initWithAsset:(Asset *)asset index:(NSInteger)index;

@end
