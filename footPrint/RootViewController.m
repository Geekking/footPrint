//
//  RootViewController.m
//  footprint
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "RootViewController.h"

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
- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}
//-(BOOL) respondsToSelector:(SEL)aSelector {
//    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
//    return [super respondsToSelector:aSelector];
//}
- (void)initUserInterface{
    self.firstViewContrller = [[MyFPViewController alloc] init];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:self.firstViewContrller];
    self.friendsViewController = [[FriendsViewController alloc] init];
    UINavigationController *friendNav = [[UINavigationController alloc] initWithRootViewController:self.friendsViewController];
    
    self.aroundViewController = [[AroundFPViewController alloc] init];
    UINavigationController *aroundNav = [[UINavigationController alloc] initWithRootViewController:self.aroundViewController];
    self.moreViewController = [[MoreViewController alloc] init];
    UINavigationController *moreNav = [[UINavigationController alloc] initWithRootViewController:self.moreViewController];

    UITabBarItem *fiItem = [[UITabBarItem alloc] initWithTitle:@"足迹" image:nil selectedImage:nil];
    firstNav.tabBarItem = fiItem;
    
    UITabBarItem *frItem = [[UITabBarItem alloc] initWithTitle:@"朋友" image:nil selectedImage:nil];
    friendNav.tabBarItem = frItem;
    
    UITabBarItem *arItem = [[UITabBarItem alloc] initWithTitle:@"周围" image:nil selectedImage:nil];
    aroundNav.tabBarItem = arItem;
    
    UITabBarItem *moItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:nil selectedImage:nil];
    moreNav.tabBarItem = moItem;
    
    self.delegate = self;
    
    self.viewControllers = [NSArray arrayWithObjects:firstNav,friendNav,aroundNav,moreNav, nil];
    
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
