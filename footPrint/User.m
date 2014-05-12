//
//  User.m
//  footprint
//
//  Created by apple on 3/24/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithUid:(NSString *)uID nickName:(NSString *)nickName personImg:(NSString *)personImg{
    self = [super init];
    if (self) {
        self.uID = uID;
        self.nickName = nickName;
        self.personImg = personImg;
    }
    return self;
}
- (NSString *)getUID{
    return  self.uID;
}
- (NSString *)getNickname{
    return self.nickName;
}
- (NSString *)getPersonImg{
    return self.personImg;

}
@end
