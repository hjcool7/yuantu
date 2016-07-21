//
//  QQApiManager.m
//  yuantu
//
//  Created by ayibang on 16/7/21.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "QQApiManager.h"
#import "Asset.h"
#import "UIImage+Orientation.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

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
    _oauth = [[TencentOAuth alloc] initWithAppId:@"1105486601" andDelegate:self];
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

@end
