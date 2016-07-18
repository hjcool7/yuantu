//
//  AlbumViewController.m
//  yuantu
//
//  Created by ayibang on 16/7/15.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "AlbumViewController.h"
#import "PictureManager.h"
#import "AssetCollection.h"
#import "UIView+AutoLayout.h"
#import "AlbumTableViewCell.h"
#import "AlbumPictureListViewController.h"

@interface AlbumViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AlbumViewController
{
    UITableView *_tableView;
    NSArray<AssetCollection *> *_allAlbums;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    
    _tableView = [[UITableView alloc] init];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView setEdgeConstraints:UIEdgeInsetsZero];
    
    [[PictureManager sharedManager] fetchAllAlbumsWithCompletion:^(NSArray<AssetCollection *> *allAlbums)
     {
         _allAlbums = allAlbums;
         [_tableView reloadData];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allAlbums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 9;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.userInteractionEnabled = NO;
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kAlbumTableViewCellReuseId];
    if (!cell)
    {
        cell = [[AlbumTableViewCell alloc] init];
    }
    
    cell.collection = _allAlbums[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetCollection *collection = _allAlbums[indexPath.section];
    AlbumPictureListViewController *albumPictureListViewController = [[AlbumPictureListViewController alloc] initWithAssetCollection:collection];
    [self.navigationController pushViewController:albumPictureListViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
