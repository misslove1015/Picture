//
//  AppDelegate.m
//  VideoAndPic
//
//  Created by miss on 17/3/16.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import "AppDelegate.h"

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([USER_DEFAULTS boolForKey:@"touchIDIsOpen"]) {
        UIViewController *fingerprint = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"fingerprint"];
        self.window.rootViewController = fingerprint;
    }    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([USER_DEFAULTS boolForKey:@"touchIDIsOpen"]) {
        NSDate *date = [NSDate date];
        [USER_DEFAULTS setObject:date forKey:@"lockTime"];
        [USER_DEFAULTS synchronize];
    }
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if ([USER_DEFAULTS boolForKey:@"touchIDIsOpen"]) {
        if ([self isFiveMinute]) {
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"fingerprint"];
            self.window.rootViewController = viewController;
        }
        
    }
    
}

- (BOOL)isFiveMinute{
    if ([USER_DEFAULTS objectForKey:@"lockTime"]) {
        NSDate *startTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lockTime"];
        long timeSpace = [[NSDate date] timeIntervalSince1970] - [startTime timeIntervalSince1970];
        if (timeSpace > 60) {
            return YES;
        }else{
            return NO;
        }
        
    }else{
        return NO;
    }
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
