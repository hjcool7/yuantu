//
//  WeiboApiManager.m
//  yuantu
//
//  Created by ayibang on 16/7/27.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "WeiboApiManager.h"
#import "Toast.h"
#import "Asset.h"
#import "UIImage+Orientation.h"

@implementation WeiboApiManager

+ (instancetype)sharedManager
{
    static WeiboApiManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WeiboApiManager alloc] init];
    });
    return manager;
}

- (void)registerApp
{
    [WeiboSDK registerApp:@"329815414"];
}

- (BOOL)canShare
{
    return ([WeiboSDK isCanShareInWeiboAPP] && [WeiboSDK isWeiboAppInstalled]);
}

- (void)shareWithImage:(UIImage *)image
{
    WBMessageObject *message = [WBMessageObject message];
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = image.shareImage.imageData;
    message.imageObject = imageObject;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    [WeiboSDK sendRequest:request];
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

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess)
        {
            [Toast showToastWithText:@"分享成功"];
        }
        else
        {
            [Toast showToastWithText:@"分享失败"];
        }
    }

}

@end
