//
//  WXApiManager.m
//  yuantu
//
//  Created by 季成 on 16/7/21.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "WXApiManager.h"
#import "Asset.h"
#import "UIImage+Orientation.h"
#import "Toast.h"

@implementation WXApiManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)registerApp
{
    [WXApi registerApp:@"wx6430742b4ef1d550"];
}

- (BOOL)canShare
{
    return ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]);
}

- (void)shareWithImage:(UIImage *)fullImage scene:(int)scene
{
    WXMediaMessage *mediaMessage = [WXMediaMessage message];
    [mediaMessage setThumbImage:fullImage.thumbnailImage];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = fullImage.shareImage.imageData;
    mediaMessage.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = mediaMessage;
    req.scene = scene;
    [WXApi sendReq:req];
}

- (void)shareWithAsset:(Asset *)asset scene:(int)scene
{
    UIImage *fullImage = [asset fullImage];
    [self shareWithImage:fullImage scene:scene];
}

- (void)shareWithMediaInfo:(NSDictionary *)mediaInfo scene:(int)scene
{
    UIImage *image = [[mediaInfo objectForKey:UIImagePickerControllerOriginalImage] fixedOrientationImage];
    [self shareWithImage:image scene:scene];
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0)
        {
            [Toast showToastWithText:@"分享成功"];
        }
        else
        {
            [Toast showToastWithText:resp.errStr ? : @"分享失败"];
        }
    }
}

- (void)onReq:(BaseReq *)req
{

}

@end
