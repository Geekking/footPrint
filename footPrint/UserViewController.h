//
//  UserViewController.h
//  footprint
//
//  Created by apple on 3/23/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UILabel *userID;
@property (weak, nonatomic) IBOutlet UIButton *extraBtn;

@property (weak, nonatomic) IBOutlet UIImageView *personalImage;
- (IBAction)tabOnBtn:(id)sender;
- (id)initWithUserID:(NSString *)userID nickName:(NSString *)nickName personalImageUrl:(NSString *)imageUrl;

@end
