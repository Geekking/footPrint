//
//  MyFPViewController.h
//  foot print
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>
static BOOL nibsRegistered = NO;

@interface MyFPViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
+ (void)setNibRegistered:(BOOL)value;

@end
