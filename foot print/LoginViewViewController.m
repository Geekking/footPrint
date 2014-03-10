//
//  LoginViewViewController.m
//  footprint
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "LoginViewViewController.h"
#import "FPHttpClient.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@interface LoginViewViewController ()

@property (strong,nonatomic)MBProgressHUD *HUD;

@end

@implementation LoginViewViewController

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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleBordered target:self action:@selector( registerButtonTabbed )];
    [regist pushNavigationItem:regItem animated:NO];
    [regItem setRightBarButtonItem:rightButton];
    [self.view addSubview:regist];
    self.passwordField.secureTextEntry = YES;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.userNameField.text = [userDefault objectForKey:@"userID"];
    self.passwordField.text = [userDefault objectForKey:@"password"];
    self.userNameField.text = @"791283555@qq.com";
    self.passwordField.text = @"627116";
    
    // self.title = @"足迹";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userNameField.placeholder = @" input your name";
    self.passwordField.placeholder = @" input your password";
    [self initUserInterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTbbed:(id)sender {
    if ([[self.userNameField text] length] == 0) {
        self.userNameField.placeholder = @"please input your name";
        return ;
    }else if([[self.userNameField text] length] <6){
        self.passwordField.placeholder = @"please input your password";
        return ;
    }else{
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        //[self.navigationController.view addSubview:_HUD];
        [self.view addSubview:_HUD];
        _HUD.dimBackground = YES;
        
        // Regiser for HUD callbacks so we can remove it from the window at the right time
        _HUD.delegate = self;
        _HUD.labelText = @"Loging...";
        
        // Show the HUD while the provided method executes in a new thread
        [_HUD showWhileExecuting:@selector(login) onTarget:self withObject:nil animated:YES];
        
        
    }
    
}
- (void)login{
    [[FPHttpClient sharedHttpClient] loginWithUserName:[self.userNameField text] password:[self.passwordField text] completion:^(NSDictionary *result, NSError *error){
        NSNumber *num = [NSNumber numberWithInt:300];
        if([result[@"code"] isEqualToNumber:num]){
            NSLog(@"login success");
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            [userDefault setObject:self.userNameField.text forKey:@"userID"];
            [userDefault setObject:self.userNameField.text forKey:@"password"];
            AppDelegate *shareDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            RootViewController *tabViewController = [[RootViewController alloc] init];
            tabViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            shareDelegate.window.rootViewController = tabViewController;
            [self dismissViewControllerAnimated:YES completion:nil];
            [self removeFromParentViewController];
        }else{
            NSLog(@"%@",result[@"phase"]);
        }
    }];
}
- (void)registerButtonTabbed{
    RegisterViewController *registerController = [[RegisterViewController alloc] init];
    registerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:registerController animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

- (IBAction)TextField_DidEndOnexit:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[_HUD removeFromSuperview];
	_HUD = nil;
}
- (IBAction)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
