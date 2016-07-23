//
//  SharePictureViewController.m
//  yuantu
//
//  Created by 季成 on 16/7/18.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "SharePictureViewController.h"
#import "AboutViewController.h"
#import "Asset.h"
#import "UIView+AutoLayout.h"
#import "UIColor+Hex.h"
#import "WXApiManager.h"
#import "Toast.h"
#import "UIImage+Orientation.h"
#import "QQApiManager.h"
#import <Social/Social.h>

@interface SharePictureViewController ()

@property (nonatomic,strong,readwrite) Asset *asset;
@property (nonatomic,copy,readwrite) NSDictionary *info;

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

- (id)initWithMediaInfo:(NSDictionary *)info
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        self.info = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享";
    self.rightNavButtonImage = [UIImage imageNamed:@"NavAbout"];
    
    CGSize imageSize = CGSizeMake(100, 133);
    imageSize.width = ceil([UIScreen mainScreen].bounds.size.width / 375 * imageSize.width);
    imageSize.height = ceil([UIScreen mainScreen].bounds.size.width / 375 * imageSize.height);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView setAlignParentCenterX];
    [imageView setTopConstraint:ceil([UIScreen mainScreen].bounds.size.width / 667 * 110)];
    [imageView setSizeConstraint:imageSize];
    
    if (self.info)
    {
        UIImage *image = [self.info objectForKey:UIImagePickerControllerOriginalImage];
        image = [image fixedOrientationImage];
        imageView.image = image;
    }
    else if (self.asset)
    {
        [self.asset requestLargeImageForTargetSize:imageSize resultHandler:^(UIImage *image,NSDictionary *info)
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
    
    CGFloat bottomSpace = ceil([UIScreen mainScreen].bounds.size.width / 667 * 100);
    CGFloat horizontalSpace = ceil(([UIScreen mainScreen].bounds.size.width - 280) / 3);

    
    UIButton *weixinSessionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    weixinSessionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [weixinSessionButton setBackgroundImage:[UIImage imageNamed:@"ShareSessionIcon"] forState:UIControlStateNormal];
    [weixinSessionButton addTarget:self action:@selector(weixinSessionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinSessionButton];
    [weixinSessionButton setSizeConstraint:CGSizeMake(50, 50)];
    [weixinSessionButton setLeftConstraint:40];
    
    UILabel *weixinSessionLabel = [[UILabel alloc] init];
    weixinSessionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    weixinSessionLabel.backgroundColor = [UIColor clearColor];
    weixinSessionLabel.font = [UIFont systemFontOfSize:13];
    weixinSessionLabel.textColor = [UIColor blackColor];
    weixinSessionLabel.text = @"微信";
    [self.view addSubview:weixinSessionLabel];
    [weixinSessionLabel setBottomConstraint:bottomSpace];
    [weixinSessionLabel setCenterXConstraint:0 toView:weixinSessionButton];
    [weixinSessionLabel setVerticalSpaceConstraint:14 topView:weixinSessionButton];
    
    UIButton *weixinTimelineButton = [UIButton buttonWithType:UIButtonTypeSystem];
    weixinTimelineButton.translatesAutoresizingMaskIntoConstraints = NO;
    [weixinTimelineButton setBackgroundImage:[UIImage imageNamed:@"ShareTimelineIcon"] forState:UIControlStateNormal];
    [weixinTimelineButton addTarget:self action:@selector(weixinTimelineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinTimelineButton];
    [weixinTimelineButton setSizeConstraint:CGSizeMake(50, 50)];
    [weixinTimelineButton setHorizontalSpaceConstraint:horizontalSpace leftView:weixinSessionButton];
    
    UILabel *weixinTimelineLabel = [[UILabel alloc] init];
    weixinTimelineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    weixinTimelineLabel.backgroundColor = [UIColor clearColor];
    weixinTimelineLabel.font = [UIFont systemFontOfSize:13];
    weixinTimelineLabel.textColor = [UIColor blackColor];
    weixinTimelineLabel.text = @"朋友圈";
    [self.view addSubview:weixinTimelineLabel];
    [weixinTimelineLabel setBottomConstraint:bottomSpace];
    [weixinTimelineLabel setCenterXConstraint:0 toView:weixinTimelineButton];
    [weixinTimelineLabel setVerticalSpaceConstraint:14 topView:weixinTimelineButton];
    
    UIButton *weiboButton = [UIButton buttonWithType:UIButtonTypeSystem];
    weiboButton.translatesAutoresizingMaskIntoConstraints = NO;
    [weiboButton setBackgroundImage:[UIImage imageNamed:@"ShareWeiboIcon"] forState:UIControlStateNormal];
    [weiboButton addTarget:self action:@selector(weiboButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboButton];
    [weiboButton setSizeConstraint:CGSizeMake(50, 50)];
    [weiboButton setHorizontalSpaceConstraint:horizontalSpace leftView:weixinTimelineButton];
    
    UILabel *weiboLabel = [[UILabel alloc] init];
    weiboLabel.translatesAutoresizingMaskIntoConstraints = NO;
    weiboLabel.backgroundColor = [UIColor clearColor];
    weiboLabel.font = [UIFont systemFontOfSize:13];
    weiboLabel.textColor = [UIColor blackColor];
    weiboLabel.text = @"微博";
    [self.view addSubview:weiboLabel];
    [weiboLabel setBottomConstraint:bottomSpace];
    [weiboLabel setCenterXConstraint:0 toView:weiboButton];
    [weiboLabel setVerticalSpaceConstraint:14 topView:weiboButton];
    
    UIButton *qzoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    qzoneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [qzoneButton setBackgroundImage:[UIImage imageNamed:@"ShareQZoneIcon"] forState:UIControlStateNormal];
    [qzoneButton addTarget:self action:@selector(qzoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qzoneButton];
    [qzoneButton setSizeConstraint:CGSizeMake(50, 50)];
    [qzoneButton setHorizontalSpaceConstraint:horizontalSpace leftView:weiboButton];
    
    UILabel *qzoneLabel = [[UILabel alloc] init];
    qzoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
    qzoneLabel.backgroundColor = [UIColor clearColor];
    qzoneLabel.font = [UIFont systemFontOfSize:13];
    qzoneLabel.textColor = [UIColor blackColor];
    qzoneLabel.text = @"QQ空间";
    [self.view addSubview:qzoneLabel];
    [qzoneLabel setBottomConstraint:bottomSpace];
    [qzoneLabel setCenterXConstraint:0 toView:qzoneButton];
    [qzoneLabel setVerticalSpaceConstraint:14 topView:qzoneButton];
    
    UILabel *shareTitleLabel = [[UILabel alloc] init];
    shareTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    shareTitleLabel.backgroundColor = [UIColor clearColor];
    shareTitleLabel.textColor = [UIColor blackColor];
    shareTitleLabel.font = [UIFont systemFontOfSize:16];
    shareTitleLabel.text = @"点击分享原始高清图";
    [self.view addSubview:shareTitleLabel];
    [shareTitleLabel setAlignParentCenterX];
    [shareTitleLabel setVerticalSpaceConstraint:ceil(40 * [UIScreen mainScreen].bounds.size.width / 667) bottomView:weixinTimelineButton];
    
    UIView *shareTitleLeftLine = [[UIView alloc] init];
    shareTitleLeftLine.translatesAutoresizingMaskIntoConstraints = NO;
    shareTitleLeftLine.backgroundColor = [UIColor hex_colorWithARGBHex:0xFFcfcfcf];
    [self.view addSubview:shareTitleLeftLine];
    [shareTitleLeftLine setSizeConstraint:CGSizeMake(45, 1)];
    [shareTitleLeftLine setCenterYConstraint:0 toView:shareTitleLabel];
    [shareTitleLeftLine setHorizontalSpaceConstraint:12 rightView:shareTitleLabel];
    
    UIView *shareTitleRightLine = [[UIView alloc] init];
    shareTitleRightLine.translatesAutoresizingMaskIntoConstraints = NO;
    shareTitleRightLine.backgroundColor = [UIColor hex_colorWithARGBHex:0xFFcfcfcf];
    [self.view addSubview:shareTitleRightLine];
    [shareTitleRightLine setSizeConstraint:CGSizeMake(45, 1)];
    [shareTitleRightLine setCenterYConstraint:0 toView:shareTitleLabel];
    [shareTitleRightLine setHorizontalSpaceConstraint:12 leftView:shareTitleLabel];
}

- (void)weixinSessionButtonClicked:(id)sender
{
    if (![[WXApiManager sharedManager] canShare])
    {
        [Toast showToastWithText:@"请安装微信"];
        return;
    }
    
    if (self.asset)
    {
        [[WXApiManager sharedManager] shareWithAsset:self.asset scene:WXSceneSession];
    }
    else if(self.info)
    {
        [[WXApiManager sharedManager] shareWithMediaInfo:self.info scene:WXSceneSession];
    }
}

- (void)weixinTimelineButtonClicked:(id)sender
{
    if (![[WXApiManager sharedManager] canShare])
    {
        [Toast showToastWithText:@"请安装微信"];
        return;
    }
    
    if (self.asset)
    {
        [[WXApiManager sharedManager] shareWithAsset:self.asset scene:WXSceneTimeline];
    }
    else if(self.info)
    {
        [[WXApiManager sharedManager] shareWithMediaInfo:self.info scene:WXSceneTimeline];
    }
}

- (void)weiboButtonClicked:(id)sender
{
    SLComposeViewController *cc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    
    [cc addImage:[self.asset fullImage]];
    
    [self presentViewController:cc animated:YES completion:nil];
}

- (void)qzoneButtonClicked:(id)sender
{
    if (![[QQApiManager sharedManager] canShare])
    {
        [Toast showToastWithText:@"请安装QQ"];
        return;
    }
    
    if (self.asset)
    {
        [[QQApiManager sharedManager] shareWithAsset:self.asset];
    }
    else if(self.info)
    {
        [[QQApiManager sharedManager] shareWithMediaInfo:self.info];
    }
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
