//
//  AppDelegate.m
//  Styler
//
//  Created by Apple on 4/25/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ShowAlertView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{

    
}
- (void) registerNotification{
    UIUserNotificationType notificationType = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:nil];
    [[UIApplication sharedApplication]registerUserNotificationSettings:notificationSettings];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSError*configError;
    [[GGLContext sharedInstance] configureWithError:&configError];
   NSAssert(!configError, @"Error configuring Google services: %@", configError);
    [GIDSignIn sharedInstance].delegate = self;
    
    [[FBSDKApplicationDelegate sharedInstance]application:application didFinishLaunchingWithOptions:launchOptions];
    [self registerNotification];
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
        return ([[GIDSignIn sharedInstance]handleURL:url
                                  sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                         annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]) ||
    ([[FBSDKApplicationDelegate sharedInstance] application:app
                                                    openURL:url
                                          sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]);
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return (([[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation]) ||
            ([[GIDSignIn sharedInstance]handleURL:url
                                sourceApplication:sourceApplication
                                       annotation:annotation]));
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if ([application applicationState] == UIApplicationStateActive){
        [ShowAlertView showAlertwithTitle:@"Notification received" andMessenge:notification.alertBody inViewController:nil];
        // update to serve
    }
    
}

@end
