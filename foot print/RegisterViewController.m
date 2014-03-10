//
//  RegisterViewController.m
//  footprint
//
//  Created by apple on 3/5/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewViewController.h"
#import "FPHttpClient.h"
@interface RegisterViewController ()

@property (strong,nonatomic)MBProgressHUD *HUD;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) initUserInterface{
    UINavigationBar *regist = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    UINavigationItem *regItem = [[UINavigationItem alloc] initWithTitle:@"Hello"];
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleBordered target:self action:@selector( loginButtonTabbed )];
    
    [regist pushNavigationItem:regItem animated:NO];
    
    [regItem setRightBarButtonItem:rightButton];
    [self.passwordField setSecureTextEntry:YES];
    self.passwordField.text = @"627116";
    self.userIDField.text = @"791283555@qq.com";
    self.nickNameField.text = @"lanny";
    
    [self.view addSubview:regist];
    // self.title = @"足迹";
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUserInterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loginButtonTabbed{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerButtonTabbed:(id)sender {
    if(self.userIDField.text.length == 0){
        self.userIDField.placeholder = @"please input your email address";
        return ;
    }
    if (self.passwordField.text.length < 6){
        self.passwordField.placeholder = @"at least 6";
        return ;
    }
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //[self.navigationController.view addSubview:_HUD];
    [self.view addSubview:_HUD];
    _HUD.dimBackground = YES;
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    _HUD.delegate = self;
    _HUD.labelText = @"Registering...";
    [_HUD showWhileExecuting:@selector(registe) onTarget:self withObject:nil animated:YES];
    
    
}
- (void)registe{
    [[FPHttpClient sharedHttpClient] registerWithUserName:self.userIDField.text password:self.passwordField.text nickName:self.nickNameField.text completion:^(NSDictionary *result, NSError *error) {
        NSNumber *num = [NSNumber numberWithInt:200];
        if ([result[@"code"] isEqualToNumber:num]) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:self.userIDField.text forKey:@"userID"];
            [userDefault setObject:self.passwordField.text forKey:@"password"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        };
    }];
}

- (IBAction)TextField_DidEndOnexit:(id)sender {
    [sender resignFirstResponder];
}


- (IBAction)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


@end
