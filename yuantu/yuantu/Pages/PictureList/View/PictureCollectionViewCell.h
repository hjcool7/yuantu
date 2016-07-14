//
//  PictureCollectionViewCell.h
//  yuantu
//
//  Created by ayibang on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

extern NSString * const kPictureCollectionViewCellReuseId;

@interface PictureCollectionViewCell : UICollectionViewCell

@property (nonatomic) CGSize pictureSize;
@property (nonatomic,strong) PHAsset *asset;

@end
