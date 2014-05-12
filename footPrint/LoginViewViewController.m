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
#import "SVProgressHUD.h"

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
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initUserInterface];
    [self initUserInterface];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] != nil){
        
        [self performSelector:@selector(loginButtonTbbed:) withObject:nil afterDelay:1.0f];
        
    }
    else{
        self.userNameField.placeholder = @" input your name";
        self.passwordField.placeholder = @" input your password";
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    
}
-(void)hello{
    NSLog(@"ddd");
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
        [SVProgressHUD showWithStatus:@"Login..."];
        [self performSelector:@selector(login) withObject:nil afterDelay:0.5f];
    }
    
}
- (void)login{
    [self.view setUserInteractionEnabled:NO];
    [[FPHttpClient sharedHttpClient] loginWithUserName:[self.userNameField text] password:[self.passwordField text] completion:^(NSDictionary *result, NSError *error){
        NSNumber *num = [NSNumber numberWithInt:300];
        if([result[@"code"] isEqualToNumber:num]){
            NSLog(@"login success");
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            [userDefault setObject:self.userNameField.text forKey:@"userID"];
            [userDefault setObject:self.passwordField.text forKey:@"password"];
            //handle login success
            RootViewController *tabViewController = [[RootViewController alloc] init];
            tabViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [SVProgressHUD showSuccessWithStatus:@"login success"];
            [SVProgressHUD showWithStatus:@"transfering"];
            [self performSelector:@selector(changeViewController:) withObject:tabViewController afterDelay:0.5f];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"login error"];
            
            [self.view setUserInteractionEnabled:YES];
            NSLog(@"%@",result[@"phase"]);
        }
    }];
}

- (void)changeViewController:(UIViewController *)viewController{
    [self presentViewController:viewController animated:YES completion:^{
        [SVProgressHUD dismiss];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *directory = [paths objectAtIndex:0];
        directory = [directory stringByAppendingString:@"/image/"];
        directory = [directory stringByAppendingString:self.userNameField.text];
        
        if([fileManager fileExistsAtPath:directory] == NO){
            BOOL Y  = [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
            NSLog(@"%d",Y);
        }
    }];
}
- (void)registerButtonTabbed{
    RegisterViewController *registerController = [[RegisterViewController alloc] init];
    registerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:registerController animated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

- (IBAction)TextField_DidEndOnexit:(id)sender {
    [sender resignFirstResponder];
}


- (IBAction)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
