//
//  AppDelegate.m
//  waterever
//
//  Created by qyyue on 2017/8/22.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "AppDelegate.h"
#import "MHLoginViewController.h"
#import "MHUserInfoTool.h"
#import "MHTabBarController.h"
#import "MHMessageTool.h"
#import "UIWindow+MHEXTENSION.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AlipaySDK/AlipaySDK.h>
#import <UMSocialCore/UMSocialCore.h>
#import <WXApi.h>
#import "AvoidCrash.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "MHReachTool.h"
#import "UMCheckUpdate.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //启动页延时1秒
    [NSThread sleepForTimeInterval:0.5];
    
    [self avoidCrash];
    
    [MHReachTool startNotifier];
    
    [self initSDK:launchOptions];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    [self.window switchRootController];
    
    application.statusBarHidden=NO;
    
    
    
    return YES;
}
    
-(void)avoidCrash{
    [AvoidCrash becomeEffective];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
}


-(void)initSDK:(NSDictionary *)launchOptions{
    [UMCheckUpdate checkUpdateWithAppID:@"1245519265"];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] openLog:NO];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"59a4dd724544cb1728000546"];
    [self configUSharePlatforms];
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.75];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    
    //向微信注册 需放在友盟的后面
    [WXApi registerApp:@"wx34203e1f020c9ce2"];
    
    //极光推送注册
    [JPUSHService setLogOFF];
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"1387fef3fc148d6e2469c48e" channel:@"App Store" apsForProduction:false advertisingIdentifier:nil];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    [MHMessageTool saveMessageWithDictionary:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MHNewNotification" object:self userInfo:nil];
}

- (void)configUSharePlatforms{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx34203e1f020c9ce2" appSecret:@"3684c9e190cbae467df0d04eeae6ecf4" redirectURL:nil];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:@"wx34203e1f020c9ce2" appSecret:@"3684c9e190cbae467df0d04eeae6ecf4" redirectURL:nil];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"894224509" appSecret:@"5058ccd30a448cbb86ab82cda103a68a" redirectURL:nil];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106101750" appSecret:nil redirectURL:nil];
}

-(void)onResp:(BaseResp *)resp{
    //微信支付回调
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getWXPayResultNotification" object:nil userInfo:@{@"resp":resp}];
}


- (BOOL)handleUrl:(NSURL *)url{
    //判断如果是支付的话 不走友盟方法 直接走微信方法
    return [[url absoluteString] rangeOfString:@"wx34203e1f020c9ce2://pay"].location == 0?[WXApi handleOpenURL:url delegate:self]:[[UMSocialManager defaultManager] handleOpenURL:url];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //向极光注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:nil];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:nil];
    }
    
    return [self handleUrl:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:nil];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:nil];
    }
    
    return [self handleUrl:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleUrl:url];
}



-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
//    3dTouch
}

- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma  mark - 接收通知
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    
    //    [MHMessageTool saveMessageWithDictionary:userInfo];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"MHNewNotification" object:self userInfo:nil];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    
}

#endif

//后台收到通知时
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    //    [MHMessageTool saveMessageWithDictionary:userInfo];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"MHNewNotification" object:self userInfo:nil];
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}



@end
