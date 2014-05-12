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
#import "SVProgressHUD.h"
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loginButtonTabbed{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//email address
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5a-zA-Z][\u4e00-\u9fa5a-zA-Z0-9]{1,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

- (IBAction)registerButtonTabbed:(id)sender {
    if([RegisterViewController validateEmail:self.userIDField.text] != YES){
        self.userIDField.placeholder = @"please input valid email address";
        return ;
    }
    if ([RegisterViewController validatePassword:self.passwordField.text] != YES){
        self.passwordField.placeholder = @"please type valie password 6";
        return ;
    }
    if([RegisterViewController validateNickname:self.nickNameField.text] != YES){
        self.passwordField.placeholder = @"please input valie nick name ";
        return ;
    }
    [SVProgressHUD showWithStatus:@"registering"];
    [self performSelector:@selector(startRegiste) withObject:nil afterDelay:0.5f];
}
- (void)startRegiste{
    [self.view setUserInteractionEnabled:NO];
    [[FPHttpClient sharedHttpClient] registerWithUserName:self.userIDField.text password:self.passwordField.text nickName:self.nickNameField.text completion:^(NSDictionary *result, NSError *error) {
        NSNumber *num = [NSNumber numberWithInt:200];
        if ([result[@"code"] isEqualToNumber:num]) {
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:self.userIDField.text forKey:@"userID"];
            [userDefault setObject:self.passwordField.text forKey:@"password"];
            
            [SVProgressHUD showSuccessWithStatus:@"registe success"];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"registe error"];
        };
    }];
    [self.view setUserInteractionEnabled:YES];
}

- (IBAction)TextField_DidEndOnexit:(id)sender {
    [sender resignFirstResponder];
}
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
