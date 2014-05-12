//
//  AppDelegate.m
//  foot print
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "RootViewController.h"

#import "MyFPViewController.h"
#import "AroundFPViewController.h"
#import "MoreViewController.h"
#import "FriendsViewController.h"
#import "LoginViewViewController.h"
@implementation AppDelegate{
    
}

- (void)initUserInterface{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[LoginViewViewController alloc] init];
    /*
    MyFPViewController *firstViewContrller = [[MyFPViewController alloc] init];
    UITabBarItem *fiItem = [[UITabBarItem alloc] initWithTitle:@"足迹" image:nil selectedImage:nil];
    firstViewContrller.tabBarItem = fiItem;
    
    FriendsViewController *friendsViewController = [[FriendsViewController alloc] init];
    UITabBarItem *frItem = [[UITabBarItem alloc] initWithTitle:@"朋友" image:nil selectedImage:nil];
    friendsViewController.tabBarItem = frItem;
    
    AroundFPViewController *aroundViewController = [[AroundFPViewController alloc] init];
    UITabBarItem *arItem = [[UITabBarItem alloc] initWithTitle:@"周围" image:nil selectedImage:nil];
    aroundViewController.tabBarItem = arItem;
    
    MoreViewController *moreViewController = [[MoreViewController alloc] init];
    UITabBarItem *moItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:nil selectedImage:nil];
    moreViewController.tabBarItem = moItem;
    
    tabViewController.delegate = self;
    
    tabViewController.viewControllers = [NSArray arrayWithObjects:firstViewContrller,friendsViewController,aroundViewController,moreViewController, nil];
    [self.window makeKeyAndVisible];
    */
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self initUserInterface];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    return YES;
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
