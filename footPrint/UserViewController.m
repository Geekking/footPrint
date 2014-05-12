//
//  UserViewController.m
//  footprint
//
//  Created by apple on 3/23/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "UserViewController.h"
#import "FPHttpClient.h"
#import "UIImageView+AFNetworking.h"

@interface UserViewController ()

@property (strong,nonatomic) NSString *personlImageUrl;
@property (strong,nonatomic) NSString *nickName;
@property (strong,nonatomic) NSString *uID;

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)initUserInterface{
    [self.userNickName setText:self.nickName];
    [self.userID setText:self.uID];
    
    if (self.personlImageUrl == nil) {
        return;
    }
    __weak UserViewController *weakCell = self;
    NSString *urlString = [[FPHttpClient getBaseURL] stringByAppendingString:@"file/"];
    urlString = [urlString stringByAppendingString:self.personlImageUrl];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"personlImageplaceHoder"];
    [self.personalImage setImageWithURLRequest:request
                           placeholderImage:placeholderImage
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        weakCell.personalImage.image = image;
                                        
                                    }failure:nil];
    
    

}
- (id)initWithUserID:(NSString *)userID nickName:(NSString *)nickName personalImageUrl:(NSString *)imageUrl{
    self = [super init];
    if (self) {
        self.personlImageUrl = imageUrl;
        self.nickName = nickName;
        self.uID = userID;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUserInterface];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tabOnBtn:(id)sender {
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    
    [client addNewFriendsWithFriendID:self.userID.text completion:^(NSDictionary *results, NSError *error) {
        if ([results[@"code"] isEqualToNumber:@550]) {
            NSLog(@"add success");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加成功" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加失败" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }];
}


@end
