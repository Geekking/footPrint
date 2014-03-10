//
//  RootViewController.m
//  footprint
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "RootViewController.h"
#import "MoreViewController.h"
#import "FriendsViewController.h"
#import "AroundFPViewController.h"
#import "MyFPViewController.h"

@interface RootViewController ()<UITabBarControllerDelegate>

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initUserInterface{
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
    
    self.delegate = self;
    
    self.viewControllers = [NSArray arrayWithObjects:firstViewContrller,friendsViewController,aroundViewController,moreViewController, nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUserInterface];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
