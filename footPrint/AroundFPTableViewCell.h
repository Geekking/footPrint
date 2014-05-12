//
//  AroundFPTableViewCell.h
//  footprint
//
//  Created by apple on 5/2/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FootPrint;
@interface AroundFPTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

- (void)configureCell:(FootPrint *)fp;
@end
