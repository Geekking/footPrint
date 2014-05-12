//
//  User.h
//  footprint
//
//  Created by apple on 3/24/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (strong,nonatomic) NSString *uID;
@property (strong,nonatomic) NSString *nickName;
@property (strong,nonatomic) NSString *personImg;

- (id)initWithUid:(NSString *)uID nickName:(NSString *)nickName personImg:(NSString *)personImg;
- (NSString *)getUID;
- (NSString *)getNickname;
- (NSString *)getPersonImg;

@end
