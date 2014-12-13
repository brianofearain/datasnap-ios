//
//  AppDelegate.m
//  gimbalDemo
//
//  Created by Mark Watson on 8/7/14.
//  Copyright (c) 2014 Datasnap.io. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DataSnapClient/Client.h"
#import "DataSnapClient.h"
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>


#import <ContextCore/QLContextCoreConnector.h>

const char MyConstantKey;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DataSnapClient setupWithOrgAndProjIDs:@"3HRhnUtmtXnT1UHQHClAcP"
                                  projectId:@"3HRhnUtmtXnT1UHQHClAcP"
                                  APIKey:@"5Z0TKJ8GLZOR40IU4CBOEH78B"
                                  APISecret:@"PDGIbwW25CbUkRSIp/OOB+WniDDudG/Pu+jfjzAEfwQ"];
    
    //staging - ALL of these IDs are ok to keep in source, they are just demo app keys.
    //[DataSnapClient setupWithOrganizationID:@"3HRhnUtmtXnT1UHQHClAcP"
    //                                 APIKey:@"1EM53HT8597CC7Q5QP0U8DN73"
    //                              APISecret:@"CcduyakRsZ8AQ/HLdXER2EjsCOlf29CTFVk/BctFmQM"];

    // Handle launching from a notification
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    else // iOS 7 or earlier
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }

    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
        [[DataSnapClient sharedClient] genericEvent:@{@"event": @"App loaded from notification"}];
    }

    QLContextCoreConnector *connector = [QLContextCoreConnector new];
    [connector enableFromViewController:self.window.rootViewController success:^
    {
        NSLog(@"Gimbal enabled");
    } failure:^(NSError *error) {
        NSLog(@"Failed to initialize gimbal %@", error);
    }];

    return YES;
}

- (void) clearNotifications {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        NSLog(@"local notification and application is active");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gimbal Event"
                                                        message:notification.alertBody
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No",nil];
        [alert show];
        objc_setAssociatedObject(alert, &MyConstantKey, notification.userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        NSLog(@"local notification and application not active");
        [[DataSnapClient sharedClient] interactionEvent:notification.userInfo fromTap:@"communication_open"];
    }
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"yes chosen");
        NSDictionary *associatedDictionary = objc_getAssociatedObject(alertView, &MyConstantKey);
        NSLog(@"associated dictionary: %@", associatedDictionary);
        [[DataSnapClient sharedClient] interactionEvent:associatedDictionary fromTap:@"communication_yes"];
    }
    else if (buttonIndex == 1) {
        NSLog(@"no chosen");
        NSDictionary *associatedDictionary = objc_getAssociatedObject(alertView, &MyConstantKey);
        NSLog(@"associated dictionary: %@", associatedDictionary);
        [[DataSnapClient sharedClient] interactionEvent:associatedDictionary fromTap:@"communication_no"];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
