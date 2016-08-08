//
//  AppDelegate.m
//  yuantu
//
//  Created by 季成 on 16/7/14.
//  Copyright © 2016年 jicheng. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "MainViewController.h"
#import "WXApiManager.h"
#import "QQApiManager.h"
#import "WeiboApiManager.h"
#import "AppInfoManager.h"
#import "WelcomeView.h"
#import "UserPreference.h"
#import <UMMobClick/MobClick.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]])
    {
        return YES;
    }
    
    if ([TencentOAuth HandleOpenURL:url])
    {
        return YES;
    }
    
    if ([QQApiInterface handleOpenURL:url delegate:[QQApiManager sharedManager]])
    {
        return YES;
    }
    
    if ([WeiboSDK handleOpenURL:url delegate:[WeiboApiManager sharedManager]])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]])
    {
        return YES;
    }
    
    if ([TencentOAuth HandleOpenURL:url])
    {
        return YES;
    }
    
    if ([QQApiInterface handleOpenURL:url delegate:[QQApiManager sharedManager]])
    {
        return YES;
    }
    
    if ([WeiboSDK handleOpenURL:url delegate:[WeiboApiManager sharedManager]])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UMConfigInstance.appKey = @"5795bbe067e58ec1800019e6";
#ifdef DEBUG
    UMConfigInstance.channelId = @"Debug";
#else
    UMConfigInstance.channelId = @"App Store";
#endif
    [MobClick setAppVersion:[AppInfoManager sharedManager].version];
    [MobClick startWithConfigure:UMConfigInstance];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    NSString *currentVersion = [AppInfoManager sharedManager].version;
    NSString *savedVersion = [UserPreference sharedPreference].currentVersion;
    if (!savedVersion || ![currentVersion isEqualToString:savedVersion])
    {
        WelcomeView *welcomeView = [[WelcomeView alloc] initWithFrame:self.window.bounds];
        [self.window addSubview:welcomeView];
        [UserPreference sharedPreference].currentVersion = currentVersion;
    }

    [[WXApiManager sharedManager] registerApp];
    [[QQApiManager sharedManager] registerApp];
    [[WeiboApiManager sharedManager] registerApp];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
