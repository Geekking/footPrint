//
//  Comment.h
//  footprint
//
//  Created by apple on 5/6/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject{
    NSString *_commentContent;
}
- (void)initWithCommentUser:(NSString *)commentUser Content:(NSString *)content User:(NSString *)userName Time:(NSString *)timeStamp;

@property (strong,nonatomic) NSString *commentConent;
@property (strong,nonatomic) NSString *commentUser;
@property (strong,nonatomic) NSString *commentPosition;
@property (strong,nonatomic) NSString *commentLocation;
@property (strong,nonatomic) NSString *commentTime;

@end
