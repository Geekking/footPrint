//
//  FPMyFriendsManager.h
//  footprint
//
//  Created by apple on 3/22/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "FMDatabase.h"
#include "FMResultSet.h"
#include "FMDatabaseQueue.h"

@interface FPMyFriendsManager : NSObject

@property (strong,nonatomic) FMDatabaseQueue *queue;
+ (FPMyFriendsManager *)sharedFriendsManager;

- (void )fetchAllMyFriends:(void (^)(NSMutableArray *))completionHandler;
//- (void)refreshNewFriends;

//- (BOOL)deleteAFriend:(NSString *)friendID;
//- (BOOL)addAFriendsIntoBlackList:(NSString *)friendID;
//- (BOOL)resetAFriendsFromBlackList:(NSString *)friendID;
@end
