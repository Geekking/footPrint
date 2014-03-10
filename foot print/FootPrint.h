//
//  FootPrint.h
//  footPrint
//
//  Created by apple on 2/27/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kOnlyToMyself          = 0,            //仅自己可见
    kOnlyToSomeFriends     = 1,            //仅提到的好友可见
    kOnlyToAllFriends      = 2,            //仅好友可见
    kOnlyToPswFriends      = 3,            //仅对有密码的好友可见
    kPublicToAll           = 4             //公开
    
}SecureType;

@interface FootPrint : NSMutableDictionary

- (id)initWithDescription:(NSString*)description coverImage:(UIImage *)coverImage currentPosition:(NSString *)currentPosition informUserList:(NSArray *)informedUserList secureType:(SecureType) secureType videoURL:(NSURL *)videoURL;

//TODO: initFrom Network

//- (FootPrint *)initWithNetwork;
- (UIImage *)getImage;
- (NSURL *)getFileURL;
- (NSDictionary *)getParam;
@end
