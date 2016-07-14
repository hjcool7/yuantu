//
//  MainViewController.m
//  yuantu
//
//  Created by ayibang on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "MainViewController.h"
#import "PictureManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitleImage"]];
    self.leftNavButtonImage = [UIImage imageNamed:@"MainAlbums"];
    self.rightNavButtonImage = [UIImage imageNamed:@"MainCamera"];
    
    [[PictureManager sharedManager] fetchAllPictures];
}

- (void)pictureChanged
{
    self.pictures = [PictureManager sharedManager].allPictures;
    [super pictureChanged];
}

- (void)leftNavButtonClicked:(id)sender
{
    
}

- (void)rightNavButtonClicked:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
