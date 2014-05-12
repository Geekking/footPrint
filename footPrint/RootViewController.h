//
//  RootViewController.h
//  footprint
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MoreViewController.h"
#import "FriendsViewController.h"
#import "AroundFPViewController.h"
#import "MyFPViewController.h"
@interface RootViewController : UITabBarController
@property(strong,nonatomic) MyFPViewController *firstViewContrller;
@property(strong,nonatomic)FriendsViewController *friendsViewController;
@property(strong,nonatomic) AroundFPViewController *aroundViewController;
@property(strong,nonatomic) MoreViewController *moreViewController;


@end
