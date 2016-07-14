//
//  BaseViewController.m
//  yuantu
//
//  Created by ayibang on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController.viewControllers.count > 1)
    {
        self.leftNavButtonImage = [UIImage imageNamed:@"NavBarBack"];
    }
}

- (void)setLeftNavButtonImage:(UIImage *)leftNavButtonImage
{
    _leftNavButtonImage = leftNavButtonImage;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(leftNavButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:_leftNavButtonImage forState:UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setRightNavButtonImage:(UIImage *)rightNavButtonImage
{
    _rightNavButtonImage = rightNavButtonImage;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(rightNavButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:_rightNavButtonImage forState:UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)leftNavButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightNavButtonClicked:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
