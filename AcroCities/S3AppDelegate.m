//
//  S3AppDelegate.m
//  AcroCities
//
//  Created by Michael Herring on 1/5/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3AppDelegate.h"

#import "S3IntroViewController.h"

#import <Parse/Parse.h>
#import <GameKit/GameKit.h>

@implementation S3AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Parse set up
    [Parse setApplicationId:@"SbHMdZO1PekFyf5mwESJPMV5E8et4IFwzvYnN8fK"
                  clientKey:@"DSzUi4uQwmSNOrCa5jwavXjrYdslHCaYrdh1IrbY"];

    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[S3IntroViewController alloc] initWithNibName:@"S3IntroViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [[GKLocalPlayer localPlayer] setAuthenticateHandler:^void(UIViewController* vc, NSError* err){
        if(err) {
            NSLog(@"GameKit: %@",[err localizedDescription]);
        }
        else if([[GKLocalPlayer localPlayer] isAuthenticated]) {
            NSLog(@"Logged in to Game Center.");
        }
        else if(vc) {
            [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    }];

    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    [PFPush storeDeviceToken:newDeviceToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, ""
    [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:@"channels"];
    [[PFInstallation currentInstallation] saveEventually];
    NSLog(@"Did register for remote notifications.");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    NSLog(@"did receive remote notification");
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"oh dear: %@",error);
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
