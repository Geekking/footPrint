//
//  AroundFPViewController.h
//  foot print
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>

static BOOL AroundnibsRegistered = NO;

@interface AroundFPViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *nearFPs;
+ (void)setAroundnibRegistered:(BOOL)value;

@end
