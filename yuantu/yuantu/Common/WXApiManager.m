//
//  WXApiManager.m
//  yuantu
//
//  Created by ayibang on 16/7/21.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "WXApiManager.h"
#import "Asset.h"
#import "UIImage+Orientation.h"

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

- (void)shareWithAsset:(Asset *)asset scene:(int)scene
{
    WXMediaMessage *mediaMessage = [WXMediaMessage message];
    [mediaMessage setThumbImage:[asset thumbnailImage]];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = [asset imageData];
    mediaMessage.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = mediaMessage;
    req.scene = scene;
    [WXApi sendReq:req];
}

- (void)shareWithMediaInfo:(NSDictionary *)mediaInfo scene:(int)scene
{
    WXMediaMessage *mediaMessage = [WXMediaMessage message];
    UIImage *image = [[mediaInfo objectForKey:UIImagePickerControllerOriginalImage] fixedOrientationImage];
    [mediaMessage setThumbImage:image];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImagePNGRepresentation(image);
    mediaMessage.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = mediaMessage;
    req.scene = scene;
    [WXApi sendReq:req];
}

- (void)onResp:(BaseResp *)resp {
//    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
//            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
//            [_delegate managerDidRecvMessageResponse:messageResp];
//        }
//    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
//            SendAuthResp *authResp = (SendAuthResp *)resp;
//            [_delegate managerDidRecvAuthResponse:authResp];
//        }
//    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
//            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
//            [_delegate managerDidRecvAddCardResponse:addCardResp];
//        }
//    } else if ([resp isKindOfClass:[WXChooseCardResp class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvChooseCardResponse:)]) {
//            WXChooseCardResp *chooseCardResp = (WXChooseCardResp *)resp;
//            [_delegate managerDidRecvChooseCardResponse:chooseCardResp];
//        }
//    }
}

- (void)onReq:(BaseReq *)req {
//    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
//            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
//            [_delegate managerDidRecvGetMessageReq:getMessageReq];
//        }
//    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
//            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
//            [_delegate managerDidRecvShowMessageReq:showMessageReq];
//        }
//    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
//            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
//            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
//        }
//    }
}

@end
