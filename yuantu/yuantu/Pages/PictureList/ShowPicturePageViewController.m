//
//  ShowPicturePageViewController.m
//  yuantu
//
//  Created by 季成 on 16/7/18.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "ShowPicturePageViewController.h"
#import "Asset.h"
#import "UIView+AutoLayout.h"

@interface ShowPicturePageViewController ()

@property (nonatomic,strong,readwrite) Asset *asset;
@property (nonatomic,readwrite) NSInteger index;

@end

@implementation ShowPicturePageViewController

- (id)initWithAsset:(Asset *)asset index:(NSInteger)index
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        self.asset = asset;
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    CGRect imageFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 164);
    [imageView setFrameConstraint:imageFrame];
    [self.asset requestLargeImageForTargetSize:imageFrame.size resultHandler:^(UIImage *image,NSDictionary *info)
    {
        if ([Asset isCancelled:info])
        {
            return;
        }
        imageView.image = image;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
