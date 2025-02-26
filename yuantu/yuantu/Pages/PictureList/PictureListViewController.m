//
//  PictureListViewController.m
//  yuantu
//
//  Created by 季成 on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "PictureListViewController.h"
#import "UIView+AutoLayout.h"
#import "PictureCollectionViewCell.h"
#import "ShowPictureViewController.h"

@interface PictureListViewController ()

@end

@implementation PictureListViewController
{
    UICollectionView *_collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.minimumInteritemSpacing = 1;
    collectionViewLayout.minimumLineSpacing = 1;
    collectionViewLayout.itemSize = [self pictureSize];
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:collectionView];
    [collectionView setAlignParentTop];
    [collectionView setWidthMatchParent];
    [collectionView setAlignParentBottom];
    
    [collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:kPictureCollectionViewCellReuseId];
    
    _collectionView = collectionView;
}

- (void)pictureChanged
{
    [_collectionView reloadData];
    if (self.pictures.count > 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pictures.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
                       });
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPictureCollectionViewCellReuseId forIndexPath:indexPath];
    cell.pictureSize = [self pictureSize];
    cell.asset = self.pictures[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowPictureViewController *showPictureViewController = [[ShowPictureViewController alloc] initWithAssets:self.pictures index:indexPath.item];
    [self.navigationController pushViewController:showPictureViewController animated:YES];
}

- (CGSize)pictureSize
{
    CGFloat pictureSize = floor(([UIScreen mainScreen].bounds.size.width - 5) / 4);
    return CGSizeMake(pictureSize, pictureSize);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
