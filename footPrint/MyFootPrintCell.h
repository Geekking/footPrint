//
//  MyFootPrintCell.h
//  footprint
//
//  Created by apple on 3/15/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FootPrint.h"

@interface MyFootPrintCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

- (void)configureCell:(FootPrint *)fp;

@end
