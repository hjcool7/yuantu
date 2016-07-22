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
#import "UIImage+Orientation.h"
#import "SharePictureViewController.h"
#import "LoadingView.h"

@interface MainViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

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
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.view.backgroundColor = [UIColor orangeColor];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    LoadingView *loadingView = [LoadingView modalLoadingView];
    [loadingView showInView:self.view];
    [picker dismissViewControllerAnimated:YES completion:^
     {
         [loadingView dismiss];
         SharePictureViewController *sharePictureViewController = [[SharePictureViewController alloc] initWithMediaInfo:info];
         [self.navigationController pushViewController:sharePictureViewController animated:YES];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
