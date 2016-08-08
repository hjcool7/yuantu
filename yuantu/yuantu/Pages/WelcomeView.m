//
//  WelcomeView.m
//  yuantu
//
//  Created by ayibang on 16/8/8.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "WelcomeView.h"
#import "UIView+AutoLayout.h"
#import "UIView+Layout.h"
#import "UIColor+Hex.h"

@interface WelcomeViewPage : UIView

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy) NSString *line1;
@property (nonatomic,copy) NSString *line2;
@property (nonatomic,strong) UIButton *button;

@end

@implementation WelcomeViewPage
{
    UIImageView *_imageView;
    UILabel *_line1Label;
    UILabel *_line2Label;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        [_imageView setAlignParentCenterX];
        [_imageView setTopConstraint:(screenSize.height < 600) ? 40 : 95];
        if (screenSize.height < 500)
        {
            [_imageView setHeightConstraint:260];
        }

        _line1Label = [[UILabel alloc] init];
        _line1Label.translatesAutoresizingMaskIntoConstraints = NO;
        _line1Label.backgroundColor = [UIColor clearColor];
        _line1Label.font = [UIFont boldSystemFontOfSize:20];
        _line1Label.textColor = [UIColor whiteColor];
        [self addSubview:_line1Label];
        [_line1Label setAlignParentCenterX];
        [_line1Label setVerticalSpaceConstraint:20 topView:_imageView];
        
        _line2Label = [[UILabel alloc] init];
        _line2Label.translatesAutoresizingMaskIntoConstraints = NO;
        _line2Label.backgroundColor = [UIColor clearColor];
        _line2Label.font = [UIFont systemFontOfSize:18];
        _line2Label.textColor = [UIColor whiteColor];
        [self addSubview:_line2Label];
        [_line2Label setAlignParentCenterX];
        [_line2Label setVerticalSpaceConstraint:14 topView:_line1Label];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.translatesAutoresizingMaskIntoConstraints = NO;
        [self.button setImage:[UIImage imageNamed:@"WelcomeButtonNormal"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"WelcomeButtonHighlighted"] forState:UIControlStateHighlighted];
        self.button.hidden = YES;
        [self addSubview:self.button];
        [self.button setVerticalSpaceConstraint:(screenSize.height < 600) ? 20 : 30 topView:_line2Label];
        [self.button setAlignParentCenterX];

    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
}

- (UIImage *)image
{
    return _imageView.image;
}

- (void)setLine1:(NSString *)line1
{
    _line1Label.text = line1;
}

- (NSString *)line1
{
    return _line1Label.text;
}

- (void)setLine2:(NSString *)line2
{
    _line2Label.text = line2;
}

- (NSString *)line2
{
    return _line2Label.text;
}


@end

@interface WelcomeView()<UIScrollViewDelegate>

@end

@implementation WelcomeView
{
    UIImageView *_pageControl;
    NSLayoutConstraint *_pageControlLeftConstraint;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        UIColor *startColor = [UIColor hex_colorWithARGBHex:0xFFff7f61];
        UIColor *endColor = [UIColor hex_colorWithARGBHex:0xFFff475c];
        
        CAGradientLayer *layer = [CAGradientLayer new];
        layer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        layer.startPoint = CGPointMake(0.5, 0);
        layer.endPoint = CGPointMake(0.5, 1);
        layer.frame = self.bounds;
        [self.layer addSublayer:layer];
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        [scrollView setEdgeConstraints:UIEdgeInsetsZero];
        
        WelcomeViewPage *page1 = [[WelcomeViewPage alloc] init];
        page1.translatesAutoresizingMaskIntoConstraints = NO;
        page1.image = [UIImage imageNamed:@"WelcomePage1"];
        page1.line1 = @"智能筛选";
        page1.line2 = @"识别所有P图、截图、下载图";
        [scrollView addSubview:page1];
        [page1 setWidthConstraint:0 toView:scrollView];
        [page1 setHeightConstraint:0 toView:scrollView];
        [page1 setHeightMatchParent];
        [page1 setAlignParentLeft];

        WelcomeViewPage *page2 = [[WelcomeViewPage alloc] init];
        page2.translatesAutoresizingMaskIntoConstraints = NO;
        page2.image = [UIImage imageNamed:@"WelcomePage2"];
        page2.line1 = @"权威认证";
        page2.line2 = @"分享原图、真是、更自信";
        page2.button.hidden = NO;
        [page2.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:page2];
        [page2 setWidthConstraint:0 toView:scrollView];
        [page2 setHeightConstraint:0 toView:scrollView];
        [page2 setHeightMatchParent];
        [page2 setAlignParentRight];
        [page2 setHorizontalSpaceConstraint:0 leftView:page1];
        
        UIImageView *pageContolBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WelcomePageControlBackground"]];
        pageContolBgView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:pageContolBgView];
        [pageContolBgView setAlignParentCenterX];
        [pageContolBgView setBottomConstraint:(screenSize.height < 600) ? 10 : 20];
        
        _pageControl = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WelcomePageControl"]];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_pageControl];
        [_pageControl setCenterYConstraint:0 toView:pageContolBgView];
        _pageControlLeftConstraint = [_pageControl setLeftConstraint:2 toView:pageContolBgView];
    }
    return self;
}

- (void)buttonClicked:(id)sender
{
    [UIView animateWithDuration:0.6 animations:^
     {
         self.alpha = 0;
     }
    completion:^(BOOL finished)
     {
         self.hidden = YES;
         [self removeFromSuperview];
     }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    _pageControlLeftConstraint.constant = 2 + 13 * x / [UIScreen mainScreen].bounds.size.width;
    [_pageControl setNeedsLayout];
}

@end
