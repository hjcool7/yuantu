//
//  AlbumTableViewCell.m
//  yuantu
//
//  Created by 季成 on 16/7/15.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "UIView+AutoLayout.h"
#import "AssetCollection.h"
#import "Asset.h"
#import "UIColor+Hex.h"

NSString *const kAlbumTableViewCellReuseId = @"kAlbumTableViewCellReuseId";

@implementation AlbumTableViewCell
{
    UIImageView *_posterImageView;
    UILabel *_titleLabel;
    UILabel *_countLabel;
    UILabel *_originalPictureCountLabel;
    PHImageRequestID _requestId;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layoutMargins = UIEdgeInsetsZero;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _posterImageView = [[UIImageView alloc] init];
        _posterImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_posterImageView];
        [_posterImageView setSizeConstraint:CGSizeMake(70, 70)];
        [_posterImageView setHeightMatchParent];
        [_posterImageView setLeftConstraint:9];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel setHorizontalSpaceConstraint:17 leftView:_posterImageView];
        [_titleLabel setTopConstraint:16];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_countLabel];
        [_countLabel setHorizontalSpaceConstraint:17 leftView:_posterImageView];
        [_countLabel setVerticalSpaceConstraint:9 topView:_titleLabel];
        
        _originalPictureCountLabel = [[UILabel alloc] init];
        _originalPictureCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _originalPictureCountLabel.backgroundColor = [UIColor clearColor];
        _originalPictureCountLabel.font = [UIFont systemFontOfSize:12];
        _originalPictureCountLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_originalPictureCountLabel];
        [_originalPictureCountLabel setHorizontalSpaceConstraint:15 leftView:_countLabel];
        [_originalPictureCountLabel setCenterYConstraint:0 toView:_countLabel];
    }
    return self;
}

- (id)init
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAlbumTableViewCellReuseId];
}

- (void)setCollection:(AssetCollection *)collection
{
    if (_collection == collection)
    {
        return;
    }
    
    _collection = collection;
    _titleLabel.text = _collection.title;
    _countLabel.text = [NSString stringWithFormat:@"%ld张",(long)(_collection.count)];
//    _originalPictureCountLabel.text = [NSString stringWithFormat:@"原图%ld张",(long)(_collection.originalPictureCount)];
    
    [Asset cancelImageRequest:_requestId];
    
    _posterImageView.hidden = YES;
    
    [[_collection.assets firstObject] requestImageForTargetSize:CGSizeMake(70, 70) resultHandler:^(UIImage *result, NSDictionary *info)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if ([Asset isCancelled:info])
                            {
                                return;
                            }
                            _posterImageView.hidden = NO;
                            _posterImageView.image = result;
                        });
     }];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted)
    {
        self.contentView.backgroundColor = [UIColor hex_colorWithARGBHex:0xFFe3e3e3];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
