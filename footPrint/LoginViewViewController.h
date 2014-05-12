//
//  LoginViewViewController.h
//  footprint
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewViewController : UIViewController <UITextFieldDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)loginButtonTbbed:(id)sender;
- (void)registerButtonTabbed;

- (IBAction)TextField_DidEndOnexit:(id)sender;

- (IBAction)View_TouchDown:(id)sender;

@end
