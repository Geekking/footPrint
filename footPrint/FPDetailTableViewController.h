//
//  FPDetailTableViewController.h
//  footprint
//
//  Created by apple on 5/6/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FootPrint.h"
@interface FPDetailTableViewController : UITableViewController
@property (strong, nonatomic)  UILabel *descriptionLabel;
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)  UILabel *locationLabel;
@property (strong, nonatomic)  UILabel *informUserList;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UIButton *playBtn;
@property (strong, nonatomic)  UIButton *commentBtn;
@property (strong, nonatomic) UITextField *commentContentText;
- (id)initWithFootPrint:(FootPrint *)fp;


@end
