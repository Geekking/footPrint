//
//  NewFPViewController.h
//  foot print
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *shortImage;
@property (weak, nonatomic) IBOutlet UILabel *currentLocation;
@property (weak, nonatomic) IBOutlet UIButton *selectSecurityType;

- (id)initWithImage:(UIImage *)image filURL:(NSURL *)fileURL;

- (IBAction)uploadButtonTapped:(id)sender;
- (IBAction)chooseSecurityTypeButtonTabbed:(id)sender;

@end

