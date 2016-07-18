//
//  AlbumTableViewCell.h
//  yuantu
//
//  Created by ayibang on 16/7/15.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssetCollection;

extern NSString *const kAlbumTableViewCellReuseId;

@interface AlbumTableViewCell : UITableViewCell

@property (nonatomic,strong) AssetCollection *collection;

@end
