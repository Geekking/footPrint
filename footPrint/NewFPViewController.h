//
//  NewFPViewController.h
//  foot print
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FPChooseFriendsDelegate
@required
-(void)getChooseFriends:(NSMutableArray *)chosenFriends;
@optional

@end

@interface NewFPViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIImageView *shortImage;
@property (weak, nonatomic) IBOutlet UILabel *currentPosition;
@property (weak, nonatomic) IBOutlet UIButton *selectSecurityType;

- (id)initWithImage:(UIImage *)image filURL:(NSURL *)fileURL;

- (IBAction)chooseSecurityTypeButtonTabbed:(id)sender;
- (IBAction)TextField_DidEndOnexit:(id)sender;
- (IBAction)View_TouchDown:(id)sender;
@end

