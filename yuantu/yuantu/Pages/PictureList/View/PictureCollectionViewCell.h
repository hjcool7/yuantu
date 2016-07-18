//
//  PictureCollectionViewCell.h
//  yuantu
//
//  Created by 季成 on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Asset;

extern NSString * const kPictureCollectionViewCellReuseId;

@interface PictureCollectionViewCell : UICollectionViewCell

@property (nonatomic) CGSize pictureSize;
@property (nonatomic,strong) Asset *asset;

@end
