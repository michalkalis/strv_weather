//
//  AppDelegate.m
//  WeatherForecast
//
//  Created by Michal Kalis on 13/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKAppDelegate.h"
#import "UIColor+MKHexString.h"

@interface MKAppDelegate ()

@end

@implementation MKAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customizeAppearance];
    
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

#pragma mark - Auxiliary

- (void)customizeAppearance {
    // Navigation bar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"white_background"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"navigation_bar_shadow_line"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:18], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]}];
    
    // Tab bar
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"white_background"]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:10], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:10], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#2f91ff"]} forState:UIControlStateSelected];
    
    // Search bar
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"Input"] forState:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"Search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"Close"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithHexString:@"#2f91ff"]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor colorWithHexString:@"#2f91ff"]];
}

@end
