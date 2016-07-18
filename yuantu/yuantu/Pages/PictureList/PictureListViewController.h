//
//  PictureListViewController.h
//  yuantu
//
//  Created by ayibang on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "PictureViewController.h"

@class Asset;

@interface PictureListViewController : PictureViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,copy) NSArray<Asset *> *pictures;

@end
