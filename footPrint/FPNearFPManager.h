//
//  FPNearFPManager.h
//  footprint
//
//  Created by apple on 4/27/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

@interface FPNearFPManager : NSObject;
@property (strong,nonatomic) FMDatabaseQueue *queue;


+ (FPNearFPManager *)sharedFriendsManager;

- (void)fetchAllMyFriendsWithDirection:(NSString *)direction Completion:(void (^)(NSArray *res,NSError *error))completion;

@end
