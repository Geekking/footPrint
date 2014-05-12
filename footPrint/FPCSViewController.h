//
//  FPCSViewController.h
//  footprint
//
//  Created by apple on 4/22/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPCSViewController : UITableViewController
- (id)initWithFriends:(NSMutableArray *)chosenFriends;
@property (strong,nonatomic) NSMutableArray *chosenFriends;

@end
