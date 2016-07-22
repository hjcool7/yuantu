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

- (void)shareWithAsset:(Asset *)asset
{
    QQApiImageArrayForQZoneObject *img = [QQApiImageArrayForQZoneObject objectWithimageDataArray:@[[asset imageData]] title:@"原图"];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    [QQApiInterface SendReqToQZone:req];
}
- (void)shareWithMediaInfo:(NSDictionary *)mediaInfo
{
    UIImage *image = [[mediaInfo objectForKey:UIImagePickerControllerOriginalImage] fixedOrientationImage];
    QQApiImageArrayForQZoneObject *img = [QQApiImageArrayForQZoneObject objectWithimageDataArray:@[UIImagePNGRepresentation(image)] title:@"原图"];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    [QQApiInterface SendReqToQZone:req];
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
        [Toast showToastWithText:resp.result ? : @""];
    }
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    
}

@end
