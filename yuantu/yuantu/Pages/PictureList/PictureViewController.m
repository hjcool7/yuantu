//
//  PictureViewController.m
//  yuantu
//
//  Created by ayibang on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureManager.h"
#import "UIView+AutoLayout.h"

@interface PictureViewController ()

@end

@implementation PictureViewController
{
    UIView *_notAuthorizedView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pictureChanged:) name:PictureManagerChangeNotification object:nil];
    
    _notAuthorizedView = [[UIView alloc] init];
    _notAuthorizedView.translatesAutoresizingMaskIntoConstraints = NO;
    _notAuthorizedView.backgroundColor = [UIColor whiteColor];
    _notAuthorizedView.hidden = YES;
    [self.view addSubview:_notAuthorizedView];
    [_notAuthorizedView setEdgeConstraints:UIEdgeInsetsZero];
    
    UILabel *notAuthorizedTextLabel = [[UILabel alloc] init];
    notAuthorizedTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    notAuthorizedTextLabel.backgroundColor = [UIColor clearColor];
    notAuthorizedTextLabel.text = @"Not Authorized";
    [_notAuthorizedView addSubview:notAuthorizedTextLabel];
    [notAuthorizedTextLabel setAlignParentCenter];
}

- (void)showNotAuthorizedView
{
    [self.view bringSubviewToFront:_notAuthorizedView];
    _notAuthorizedView.hidden = [[PictureManager sharedManager] authorized];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showNotAuthorizedView];
}

- (void)pictureChanged
{
    
}

- (void)pictureChanged:(NSNotification *)notification
{
    [self showNotAuthorizedView];
    [self pictureChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
