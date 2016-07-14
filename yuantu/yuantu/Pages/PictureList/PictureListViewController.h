//
//  PictureListViewController.h
//  yuantu
//
//  Created by ayibang on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "PictureViewController.h"
#import <Photos/Photos.h>

@interface PictureListViewController : PictureViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,copy) NSArray<PHAsset *> *pictures;

@end
