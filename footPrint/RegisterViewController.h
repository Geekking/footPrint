//
//  RegisterViewController.h
//  footprint
//
//  Created by apple on 3/5/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface RegisterViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userIDField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *nickNameField;

- (IBAction)registerButtonTabbed:(id)sender;

- (IBAction)TextField_DidEndOnexit:(id)sender;

- (IBAction)View_TouchDown:(id)sender;

@end
