//
//  AboutViewController.m
//  yuantu
//
//  Created by 季成 on 16/7/18.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "AboutViewController.h"
#import "UIView+AutoLayout.h"
#import "UIColor+Hex.h"
#import "AppInfoManager.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AboutIcon"]];
    iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:iconImageView];
    [iconImageView setAlignParentCenterX];
    [iconImageView setTopConstraint:40];
    
    UILabel *sloganLabel = [[UILabel alloc] init];
    sloganLabel.translatesAutoresizingMaskIntoConstraints = NO;
    sloganLabel.backgroundColor = [UIColor clearColor];
    sloganLabel.textColor = [UIColor blackColor];
    sloganLabel.font = [UIFont boldSystemFontOfSize:16];
    sloganLabel.text = @"原图，比滤镜更美丽";
    [self.view addSubview:sloganLabel];
    [sloganLabel setAlignParentCenterX];
    [sloganLabel setVerticalSpaceConstraint:20 topView:iconImageView];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [UIColor hex_colorWithARGBHex:0xFF5b5b5b];
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.text = [NSString stringWithFormat:@"当前版本：V%@",[AppInfoManager sharedManager].version];
    [self.view addSubview:versionLabel];
    [versionLabel setAlignParentCenterX];
    [versionLabel setVerticalSpaceConstraint:30 topView:sloganLabel];
    
    UILabel *qqLabel = [[UILabel alloc] init];
    qqLabel.translatesAutoresizingMaskIntoConstraints = NO;
    qqLabel.backgroundColor = [UIColor clearColor];
    qqLabel.textColor = [UIColor hex_colorWithARGBHex:0xFF5b5b5b];
    qqLabel.font = [UIFont systemFontOfSize:14];
    qqLabel.text = @"客服QQ：943787326";
    [self.view addSubview:qqLabel];
    [qqLabel setAlignParentCenterX];
    [qqLabel setVerticalSpaceConstraint:12 topView:versionLabel];
    
    UILabel *telLabel = [[UILabel alloc] init];
    telLabel.translatesAutoresizingMaskIntoConstraints = NO;
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.textColor = [UIColor hex_colorWithARGBHex:0xFF5b5b5b];
    telLabel.font = [UIFont systemFontOfSize:14];
    telLabel.text = @"合作电话：010-52430517";
    [self.view addSubview:telLabel];
    [telLabel setAlignParentCenterX];
    [telLabel setVerticalSpaceConstraint:12 topView:qqLabel];
    
    UIButton *scoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    scoreButton.translatesAutoresizingMaskIntoConstraints = NO;
    [scoreButton setTitle:@"亲，去赞一个吧！" forState:UIControlStateNormal];
    scoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [scoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scoreButton.backgroundColor = [UIColor hex_colorWithARGBHex:0xFFff495d];
    scoreButton.clipsToBounds = YES;
    scoreButton.layer.cornerRadius = 4;
    [scoreButton addTarget:self action:@selector(scoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scoreButton];
    [scoreButton setBottomConstraint:50];
    [scoreButton setHeightConstraint:40];
    [scoreButton setWidthMatchParentWithPadding:40];
}

- (void)scoreButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[AppInfoManager sharedManager].appStoreUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
