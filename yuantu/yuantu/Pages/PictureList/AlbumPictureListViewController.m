//
//  AlbumPictureListViewController.m
//  yuantu
//
//  Created by 季成 on 16/7/15.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "AlbumPictureListViewController.h"
#import "AssetCollection.h"

@interface AlbumPictureListViewController ()

@end

@implementation AlbumPictureListViewController
{
    AssetCollection *_collection;
}


- (id)initWithAssetCollection:(AssetCollection *)assetCollection
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        _collection = assetCollection;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _collection.title;
    self.pictures = _collection.assets;
    [super pictureChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
