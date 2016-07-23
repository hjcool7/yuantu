//
//  PictureCollectionViewCell.m
//  yuantu
//
//  Created by 季成 on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "PictureCollectionViewCell.h"
#import "UIView+AutoLayout.h"
#import "PictureManager.h"
#import "Asset.h"

NSString * const kPictureCollectionViewCellReuseId = @"kPictureCollectionViewCellReuseId";

@implementation PictureCollectionViewCell
{
    PHImageRequestID _requestId;
    UIImageView *_imageView;
    UIImageView *_eyeImageView;
    UIView *_maskView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill
        ;
        _imageView.clipsToBounds = YES;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_imageView];
        [_imageView setEdgeConstraints:UIEdgeInsetsZero];
        
        _eyeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PictureEye"]];
        _eyeImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _eyeImageView.hidden = YES;
        [self.contentView addSubview:_eyeImageView];
        [_eyeImageView setLeftConstraint:4];
        [_eyeImageView setTopConstraint:4];
        
        _maskView = [[UIView alloc] init];
        _maskView.translatesAutoresizingMaskIntoConstraints = NO;
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _maskView.hidden = YES;
        [self.contentView addSubview:_maskView];
        [_maskView setEdgeConstraints:UIEdgeInsetsZero];
    }
    return self;
}

- (void)setAsset:(Asset *)asset
{
    if (_asset == asset)
    {
        return;
    }
    
    _asset = asset;
    [Asset cancelImageRequest:_requestId];
    
    _imageView.hidden = YES;
    _eyeImageView.hidden = YES;
    
    [_asset requestIsOriginalWithResultHandler:^(Asset *asset, BOOL isOriginal)
    {
        if (asset == _asset)
        {
            _eyeImageView.hidden = isOriginal;
        }
    }];
    
    [_asset requestImageForTargetSize:self.pictureSize resultHandler:^(UIImage *result, NSDictionary *info)
    {
        dispatch_async(dispatch_get_main_queue(), ^
           {
               if ([Asset isCancelled:info])
               {
                   return;
               }
               _imageView.hidden = NO;
               _imageView.image = result;
           });
    }];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    _maskView.hidden = !highlighted;
}

@end
