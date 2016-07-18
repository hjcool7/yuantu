//
//  MainViewController.m
//  yuantu
//
//  Created by 季成 on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "MainViewController.h"
#import "PictureManager.h"
#import "AlbumViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitleImage"]];
    self.leftNavButtonImage = [UIImage imageNamed:@"MainAlbums"];
    self.rightNavButtonImage = [UIImage imageNamed:@"MainCamera"];
    
    [[PictureManager sharedManager] fetchAllPicturesWithCompletion:^(NSArray<PHAsset *> *allPictures)
     {
         self.pictures = [PictureManager sharedManager].allPictures;
         [self pictureChanged];
     }];
}

- (void)leftNavButtonClicked:(id)sender
{
    AlbumViewController *albumViewController = [[AlbumViewController alloc] init];
    [self.navigationController pushViewController:albumViewController animated:YES];
}

- (void)rightNavButtonClicked:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
