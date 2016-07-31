//
//  QQApiManager.m
//  yuantu
//
//  Created by 季成 on 16/7/21.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "QQApiManager.h"
#import "Asset.h"
#import "UIImage+Orientation.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "Toast.h"

@implementation QQApiManager
{
    TencentOAuth *_oauth;
}

+ (instancetype)sharedManager
{
    static QQApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QQApiManager alloc] init];
    });
    return manager;
}

- (void)registerApp
{
    _oauth = [[TencentOAuth alloc] initWithAppId:@"1105500046" andDelegate:self];
}

- (BOOL)canShare
{
    return ([QQApiInterface isQQSupportApi] && [QQApiInterface isQQInstalled]);
}

- (void)shareWithImage:(UIImage *)image
{
    QQApiImageArrayForQZoneObject *img = [QQApiImageArrayForQZoneObject objectWithimageDataArray:@[image.shareImage.imageData] title:@"原图"];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    [QQApiInterface SendReqToQZone:req];
}

- (void)shareWithAsset:(Asset *)asset
{
    [self shareWithImage:asset.fullImage];
}
- (void)shareWithMediaInfo:(NSDictionary *)mediaInfo
{
    UIImage *image = [[mediaInfo objectForKey:UIImagePickerControllerOriginalImage] fixedOrientationImage];
    [self shareWithImage:image];
}

- (void)tencentDidLogin
{
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

- (void)tencentDidNotNetWork
{
    
}

- (void)onReq:(QQBaseReq *)req
{
    
}

- (void)onResp:(QQBaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToQQResp class]])
    {
        if ([resp.result integerValue] == 0)
        {
            [Toast showToastWithText:@"分享成功"];
        }
        else
        {
            [Toast showToastWithText:resp.errorDescription ? : @"分享失败"];
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    
}

@end
