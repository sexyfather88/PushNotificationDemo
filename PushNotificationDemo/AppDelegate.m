//
//  AppDelegate.m
//  APNSDemo
//
//  Created by shenzhenshihua on 2017/3/17.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "ViewController.h"

#define IOS_VERSION      [[[UIDevice currentDevice] systemVersion] floatValue]


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    NSLog(@"%f",IOS_VERSION);
    if (IOS_VERSION >= 10.0) {
        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
        [center setDelegate:self];
        
        UNAuthorizationOptions type = UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert;
        [center requestAuthorizationWithOptions:type completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"Register Successfully");
            }else{
                NSLog(@"Register Failed");
            }
            
        }];
        
    }else if (IOS_VERSION >= 8.0){
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    // Register for device Token
    [application registerForRemoteNotifications];
    
    
    
    
    CGRect screen_frame=[UIScreen mainScreen].bounds;
    
    self.window=[[UIWindow alloc]initWithFrame:screen_frame];
    
    
    ViewController *page=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    
    
    self.window.rootViewController=page;
    [self.window makeKeyAndVisible];

    
    
    
    return YES;
}


// Get device token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenSt = [[[[deviceToken description]
                                 stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                stringByReplacingOccurrencesOfString:@">" withString:@""]
                               stringByReplacingOccurrencesOfString:@" " withString:@""];
    //save token to Server
    
    NSLog(@"deviceTokenSt:%@",deviceTokenSt);
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
    
}



//在前台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    //需要執行這個方法，選擇是否提醒用戶，有Badge、Sound、Alert三種類型可以設置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
    
    // UNNotificationPresentationOptionAlert=>AlertController
    // UNNotificationPresentationOptionSound=>震動和提示音
    // UNNotificationPresentationOptionBadge=>app顯示數字
    
    
}



//>=ios10的版本，三種情況都會來到這個方法

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    //未啟動App 點取alertt觸發按鈕調用的方法 根據identifier來判斷 ex:開啟或回覆功能
    
    //處理推送過來的數據
    
    completionHandler();
    
}


//ios10以下版本
//遠程推送APP在前台 或者是在後台再次返回前台 或者重新進入程序
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary * _Nonnull)userInfo fetchCompletionHandler:(void (^ _Nonnull)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    
    /*
     
     UIApplicationStateActive 應用程序處於前台
     
     UIApplicationStateBackground 應用程序在後台，用戶從通知中心點擊消息將程序從後台調至前台
     
     UIApplicationStateInactive 程序處於關閉狀態(不在前台也不在後台)，用戶通過點擊通知中心的消息將客戶端從關閉狀態調至前台
     
     */
    
    //應用程序在前台給一個提示特別消息
    
    if (application.applicationState == UIApplicationStateActive) {
        
        //應用程序在前台
        
        
    }else{
        
        //其他兩種情況，一種在後台程序沒有被殺死，另一種是在程序已經殺死。用戶點擊推送的消息進入app的情況處理。
        
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
