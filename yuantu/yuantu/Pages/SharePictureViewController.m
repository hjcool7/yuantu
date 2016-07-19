//
//  SharePictureViewController.m
//  yuantu
//
//  Created by ayibang on 16/7/18.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "SharePictureViewController.h"
#import "AboutViewController.h"
#import "Asset.h"
#import "UIView+AutoLayout.h"

@interface SharePictureViewController ()

@property (nonatomic,strong,readwrite) Asset *asset;
@property (nonatomic,strong,readwrite) UIImage *image;

@end

@implementation SharePictureViewController

- (id)initWithAsset:(Asset *)asset
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        self.asset = asset;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享";
    self.rightNavButtonImage = [UIImage imageNamed:@"NavAbout"];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView setAlignParentCenterX];
    [imageView setTopConstraint:110];
    [imageView setSizeConstraint:CGSizeMake(100, 133)];
    
    if (self.image)
    {
        imageView.image = self.image;
    }
    else if (self.asset)
    {
        [self.asset requestLargeImageForTargetSize:CGSizeMake(100, 133) resultHandler:^(UIImage *image,NSDictionary *info)
         {
             if ([Asset isCancelled:info])
             {
                 return;
             }
             imageView.image = image;
         }];
    }
    
    UILabel *sloganLabel = [[UILabel alloc] init];
    sloganLabel.translatesAutoresizingMaskIntoConstraints = NO;
    sloganLabel.backgroundColor = [UIColor clearColor];
    sloganLabel.textColor = [UIColor blackColor];
    sloganLabel.font = [UIFont boldSystemFontOfSize:16];
    sloganLabel.text = @"原图，比滤镜更美丽";
    [self.view addSubview:sloganLabel];
    [sloganLabel setAlignParentCenterX];
    [sloganLabel setVerticalSpaceConstraint:20 topView:imageView];
    
    UIButton *weixinSessionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    weixinSessionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [weixinSessionButton setBackgroundImage:[UIImage imageNamed:@"ShareSessionIcon"] forState:UIControlStateNormal];
    [weixinSessionButton addTarget:self action:@selector(weixinSessionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinSessionButton];
    [weixinSessionButton setSizeConstraint:CGSizeMake(50, 50)];
    [weixinSessionButton setLeftConstraint:ceil(([UIScreen mainScreen].bounds.size.width - 296) / 2)];
    [weixinSessionButton setBottomConstraint:100];
    
    UIButton *weixinTimelineButton = [UIButton buttonWithType:UIButtonTypeSystem];
    weixinTimelineButton.translatesAutoresizingMaskIntoConstraints = NO;
    [weixinTimelineButton setBackgroundImage:[UIImage imageNamed:@"ShareTimelineIcon"] forState:UIControlStateNormal];
    [weixinTimelineButton addTarget:self action:@selector(weixinTimelineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinTimelineButton];
    [weixinTimelineButton setSizeConstraint:CGSizeMake(50, 50)];
    [weixinTimelineButton setHorizontalSpaceConstraint:32 leftView:weixinSessionButton];
    [weixinTimelineButton setBottomConstraint:100];
    
    UIButton *weiboButton = [UIButton buttonWithType:UIButtonTypeSystem];
    weiboButton.translatesAutoresizingMaskIntoConstraints = NO;
    [weiboButton setBackgroundImage:[UIImage imageNamed:@"ShareWeiboIcon"] forState:UIControlStateNormal];
    [weiboButton addTarget:self action:@selector(weiboButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboButton];
    [weiboButton setSizeConstraint:CGSizeMake(50, 50)];
    [weiboButton setHorizontalSpaceConstraint:32 leftView:weixinTimelineButton];
    [weiboButton setBottomConstraint:100];
    
    UIButton *qzoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    qzoneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [qzoneButton setBackgroundImage:[UIImage imageNamed:@"ShareQZoneIcon"] forState:UIControlStateNormal];
    [qzoneButton addTarget:self action:@selector(qzoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qzoneButton];
    [qzoneButton setSizeConstraint:CGSizeMake(50, 50)];
    [qzoneButton setHorizontalSpaceConstraint:32 leftView:weiboButton];
    [qzoneButton setBottomConstraint:100];
    
    UILabel *shareTitleLabel = [[UILabel alloc] init];
    shareTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    shareTitleLabel.backgroundColor = [UIColor clearColor];
    shareTitleLabel.textColor = [UIColor blackColor];
    shareTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    shareTitleLabel.text = @"分享至";
    [self.view addSubview:shareTitleLabel];
    [shareTitleLabel setAlignParentCenterX];
    [shareTitleLabel setVerticalSpaceConstraint:40 bottomView:weixinTimelineButton];
    
    UIView *shareTitleLeftLine = [[UIView alloc] init];
    shareTitleLeftLine.translatesAutoresizingMaskIntoConstraints = NO;
    shareTitleLeftLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:shareTitleLeftLine];
    [shareTitleLeftLine setSizeConstraint:CGSizeMake(45, 1)];
    [shareTitleLeftLine setCenterYConstraint:0 toView:shareTitleLabel];
    [shareTitleLeftLine setHorizontalSpaceConstraint:12 rightView:shareTitleLabel];
    
    UIView *shareTitleRightLine = [[UIView alloc] init];
    shareTitleRightLine.translatesAutoresizingMaskIntoConstraints = NO;
    shareTitleRightLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:shareTitleRightLine];
    [shareTitleRightLine setSizeConstraint:CGSizeMake(45, 1)];
    [shareTitleRightLine setCenterYConstraint:0 toView:shareTitleLabel];
    [shareTitleRightLine setHorizontalSpaceConstraint:12 leftView:shareTitleLabel];
}

- (void)weixinSessionButtonClicked:(id)sender
{
    
}

- (void)weixinTimelineButtonClicked:(id)sender
{
    
}

- (void)weiboButtonClicked:(id)sender
{
    
}

- (void)qzoneButtonClicked:(id)sender
{
    
}

- (void)rightNavButtonClicked:(id)sender
{
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
