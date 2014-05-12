//
//  Comment.m
//  footprint
//
//  Created by apple on 5/6/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (void)initWithCommentUser:(NSString *)commentUser Content:(NSString *)content User:(NSString *)userName Time:(NSString *)timeStamp{
    self.commentConent = content;
    self.commentUser = userName;
    self.commentTime = timeStamp;
}
- (NSString *)getTimeStamp{
    return self.commentTime;
}
- (NSString *)getCommentContent{
    return self.commentConent;
}
- (NSString *)getCommentUser{
    return self.commentUser;
}


@end
