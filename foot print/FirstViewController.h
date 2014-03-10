//
//  FirstViewController.h
//  footPrint
//
//  Created by apple on 2/23/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadQueueButton;

- (IBAction)addVideoButtonTabbed:(id)sender;
- (IBAction)uploadVideoButtonTabbed:(id)sender;

@end
