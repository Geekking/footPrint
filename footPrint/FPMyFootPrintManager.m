//
//  FPMyFootPrintManager.m
//  footprint
//
//  Created by apple on 3/17/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "FPMyFootPrintManager.h"
#include "FMDatabase.h"
#include "FMResultSet.h"
#include "FMDatabaseQueue.h"
#include "FootPrint.h"

@interface FPMyFootPrintManager ()
@property (strong, nonatomic) FMDatabaseQueue *queue;
- (void)refreshNewlyFootPrint;
@end

@implementation FPMyFootPrintManager

+ (FPMyFootPrintManager *)sharedInstance{
    static FPMyFootPrintManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shareInstance = [[FPMyFootPrintManager alloc] init];
        shareInstance.lastFPID = 20;
        shareInstance.queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH];
    });
    return shareInstance;
}

- (void)refreshNewlyFootPrint{
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    if ([defaultUser objectForKey:@"myLastFP"]== nil) {
        [defaultUser setObject:@0 forKey:@"myLastFP"];
    }
    // get the newly data
    [client refreshFootPrintWithLastFpID: [NSString stringWithFormat:@"%@",[defaultUser objectForKey:@"myLastFP"]] completion:^(NSDictionary *results, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        // got new fp
        if ([results[@"code"]  isEqual: @450]) {
            
            __block NSArray *fpArray = [[NSArray alloc] initWithArray:results[@"result"]];
            [defaultUser setObject:[fpArray lastObject][@"fpID"] forKey:@"myLastFP"];
            
            [self.queue inDatabase:^(FMDatabase *db) {
                //create table
                NSString *createTableSql = [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY , '%@' TEXT,'%@' TEXT, '%@' INTEGER, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TIMESTAMP NOT NULL,'%@' TEXT,'%@' TEXT)",@"myFootPrint",@"fpID",@"uID",@"descript",@"secureType",@"location",@"position",@"infouIDs",@"videoTime",@"movieUrl",@"imageUrl"];
                if ([db executeUpdate:createTableSql]) {
                    NSLog(@"create table myFootPrint");
                }else{
                    NSLog(@"err when creating table");
                };
                //insert into db
                NSString *sql = @"INSERT INTO `myFootPrint` VALUES(:fpID, :uID, :descript, :secureType, :location, :position, :infouIDs, :videoTime, :movieUrl,:imageUrl)";
                for (int i=0; i < [fpArray count]; i++) {
                    if ([db executeUpdate:sql withParameterDictionary:fpArray[i] ] ) {
                        NSLog(@"insert success");
                    }else{
                        NSLog(@"%@",[db lastError]);
                    }
                    
                }
                
            }];
        }
        //TODO: handle no result and error
        
    }];
}
- (NSMutableArray *)fetchCurrentFootPrintsInPages:(NSInteger )page{
    __block NSMutableArray *fpArrays = [[NSMutableArray alloc] initWithCapacity:0];
    //TODO: get data from database
    [self refreshNewlyFootPrint];
    // fetch data from db
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *res = [db executeQuery:@"SELECT * FROM myFootPrint WHERE myFootPrint.uID = ? ORDER BY myFootPrint.videoTime DESC LIMIT ?,?",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID" ],[NSNumber numberWithLong:page*(kNumberOfFpsInaPage)],[NSNumber numberWithInt:kNumberOfFpsInaPage]];
        
        //NSLog(@"%@",[[res columnNameToIndexMap] allKeys] ) ;
       
        while ([res next]) {
            NSMutableDictionary *fpDict = [[NSMutableDictionary alloc] init];
            int fpID = [res intForColumn:@"fpID"];
            [fpDict setValue:[NSNumber numberWithInt:fpID] forKey:@"fpID"];
            [fpDict setValue:[res stringForColumn:@"uID"] forKey:@"userID"];
            [fpDict setValue:[res stringForColumn:@"descript"] forKey:@"description"];
            [fpDict setValue:[NSNumber numberWithInt:[res intForColumn:@"secureType"]] forKey:@"secureType"];
            [fpDict setValue:[res stringForColumn:@"location"] forKey:@"location"];
            [fpDict setValue:[res stringForColumn:@"position"] forKey:@"position"];
            [fpDict setValue:[res stringForColumn:@"infouIDs"] forKey:@"infouIDs"];
            [fpDict setValue:[res dateForColumn:@"videoTime"] forKey:@"videoTime"];
           
            [fpDict setValue:[res stringForColumn:@"imageUrl"] forKey:@"coverImageURL"];
            [fpDict setValue:[res stringForColumn:@"movieUrl"] forKey:@"movieUrl"];
            
            FootPrint *aFp = [[FootPrint alloc] initWithDictionary:fpDict];
            [fpArrays addObject:aFp];
        }
        
    }];
    return fpArrays;
}
// got data from updating fps

- (NSMutableArray *)fetchUpdatingFPs{
    NSMutableArray *updatingFPs = [[NSMutableArray alloc] initWithCapacity:0];
    //TODO: get data from databse;
    
    return updatingFPs;
}
// insert 
- (BOOL)insertNewUploadingFPIntoDB:(FootPrint *)fp{
    return YES;
}
@end
