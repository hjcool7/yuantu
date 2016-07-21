//
//  ShowPictureViewController.m
//  yuantu
//
//  Created by ayibang on 16/7/18.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "ShowPictureViewController.h"
#import "Asset.h"
#import "UIView+AutoLayout.h"
#import "ShowPicturePageViewController.h"
#import "Toast.h"
#import "SharePictureViewController.h"
#import "UIButton+BackgroundColor.h"
#import "UIColor+Hex.h"

@interface ShowPictureViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic,copy,readwrite) NSArray<Asset *> *assets;
@property (nonatomic,readwrite) NSInteger index;

@end

@implementation ShowPictureViewController
{
    UIPageViewController *_pageViewController;
    UIButton *_shareButton;
}

- (id)initWithAssets:(NSArray<Asset *> *)assets index:(NSInteger)index;
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        self.assets = assets;
        self.index = index;
        if (self.index >= assets.count)
        {
            self.index = 0;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitleImage"]];

    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    ShowPicturePageViewController *initialViewController =[self viewControllerWithIndex:self.index];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [pageViewController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [pageViewController.view setEdgeConstraints:UIEdgeInsetsZero];
    
    UIView *shareBackgroundView = [[UIView alloc] init];
    shareBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    shareBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shareBackgroundView];
    [shareBackgroundView setWidthMatchParent];
    [shareBackgroundView setHeightConstraint:100];
    [shareBackgroundView setAlignParentBottom];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton bg_setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    [shareButton bg_setBackgroundColor:[UIColor hex_colorWithARGBHex:0xFFb3b3b3] forState:UIControlStateDisabled];
    shareButton.clipsToBounds = YES;
    shareButton.layer.cornerRadius = 4;
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareBackgroundView addSubview:shareButton];
    [shareButton setAlignParentCenterY];
    [shareButton setHeightConstraint:40];
    [shareButton setWidthMatchParentWithPadding:40];
    
    shareButton.enabled = initialViewController.asset.isOriginal;
    
    _shareButton = shareButton;
    _pageViewController = pageViewController;
}

- (void)shareButtonClicked:(id)sender
{
    ShowPicturePageViewController *showPicturePageViewController = [_pageViewController.viewControllers firstObject];
    if (showPicturePageViewController.asset.isOriginal)
    {
        SharePictureViewController *sharePictureViewController = [[SharePictureViewController alloc] initWithAsset:showPicturePageViewController.asset];
        [self.navigationController pushViewController:sharePictureViewController animated:YES];
    }
}

- (ShowPicturePageViewController *)viewControllerWithIndex:(NSInteger)index
{
    if (index >= self.assets.count || index < 0)
    {
        return nil;
    }
    ShowPicturePageViewController *showPicturePageViewController = [[ShowPicturePageViewController alloc] initWithAsset:self.assets[index] index:index];
    return showPicturePageViewController;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return [self viewControllerWithIndex:((ShowPicturePageViewController *)viewController).index - 1];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return [self viewControllerWithIndex:((ShowPicturePageViewController *)viewController).index + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    ShowPicturePageViewController *showPicturePageViewController = [_pageViewController.viewControllers firstObject];
    _shareButton.enabled = showPicturePageViewController.asset.isOriginal;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
