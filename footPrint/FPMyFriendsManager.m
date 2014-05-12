//
//  FPMyFriendsManager.m
//  footprint
//
//  Created by apple on 3/22/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "FPMyFriendsManager.h"
#import "FPHttpClient.h"
#import "User.h"

@implementation FPMyFriendsManager
+ (FPMyFriendsManager *)sharedFriendsManager{
    static FPMyFriendsManager *sharedFPFriendsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedFPFriendsManager = [[self alloc] init];
        
        sharedFPFriendsManager.queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH];
    });
    
    return sharedFPFriendsManager;
}
- (void)fetchAllMyFriends:(void (^)(NSMutableArray *))completionHandler{
    __block NSMutableArray *frArrays = [[NSMutableArray alloc] initWithCapacity:0];
  
    [self refreshNewFriendcompletion:^{
        NSLog(@"fetch Begin:");
        [self.queue inDatabase:^(FMDatabase *db) {
            FMResultSet *res = [db executeQuery:@"SELECT * FROM myFriends WHERE uID = ? ORDER BY frID DESC",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID" ] ];
            
            while ([res next]) {
                User *aFr = [[User alloc] initWithUid:[res stringForColumn:@"frID"] nickName:[res stringForColumn:@"nickName"] personImg:[res stringForColumn:@"personalImg"] ];
                [frArrays addObject:aFr];
            }
            completionHandler(frArrays);
            
        }];
    }];
    // fetch data from db
    
}
-(void)refreshNewFriendcompletion:(void (^)(void))completionHandler{
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    
    if (![defaultUser objectForKey:@"lastFriendStamp"]) {
        [defaultUser setObject:@"0" forKey:@"lastFriendStamp"];
    }
    [client refreshFriendsWithLastTimeStamp:[defaultUser objectForKey:@"lastFriendStamp"] completion:^(NSDictionary *results, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error);
        }else{
            
            if ([results[@"code"]  isEqual: @560]) {
                NSDate *localDate = [NSDate date];
                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];
                [defaultUser setObject:timeSp forKey:@"lastFriendStamp"];
                
                __block NSArray *frArray = [[NSArray alloc] initWithArray:results[@"result"]];
                
                
                [self.queue inDatabase:^(FMDatabase *db) {
                    //create table
                    NSString *createTableSql = [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT  , '%@' TEXT,'%@' TEXT, '%@' TEXT)",@"myFriends",@"frID",@"uID",@"nickName",@"personalImg"];
                    
                    if ([db executeUpdate:createTableSql]) {
                        NSLog(@"create table myFriends");
                    }else{
                        NSLog(@"err when creating table");
                        NSLog(@"%@",[db lastError]);
                    };
                    
                    //insert into db
                    NSString *sql = @"INSERT INTO `myFriends` VALUES(:frID, :uID, :nickName, :personalImg)";
                    for (int i=0; i < [frArray count]; i++) {
                        NSMutableDictionary *aFriend = [[NSMutableDictionary alloc] initWithDictionary:frArray[i] ];
                        [aFriend setObject:[defaultUser objectForKey:@"userID"] forKey:@"uID"];
                        if ([db executeUpdate:sql withParameterDictionary:aFriend ] ) {
                            NSLog(@"insert success");
                        }else{
                            NSLog(@"...%@.....",[db lastError]);
                        }
                        
                    }
                    
                }];
                completionHandler();

            }
        }
    }];
}

@end
