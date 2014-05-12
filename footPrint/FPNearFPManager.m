//
//  FPNearFPManager.m
//  footprint
//
//  Created by apple on 4/27/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "FPNearFPManager.h"
#import "FMDatabaseQueue.h"
#import "FPHttpClient.h"

@interface FPNearFPManager() {
    NSString *lastReverseNearFPStamp;
    NSString *lastNearFPStamp;
}

@end
@implementation FPNearFPManager

+ (FPNearFPManager *)sharedFriendsManager{
    static FPNearFPManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shareInstance = [[FPNearFPManager alloc] init];
        shareInstance.queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH];
    });
    return shareInstance;
}

- (void)fetchAllMyFriendsWithDirection:(NSString *)direction Completion:(void (^)(NSArray *, NSError *))completion{
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    if (lastReverseNearFPStamp == nil) {
        lastReverseNearFPStamp = @"100000000";
    }
    if(lastNearFPStamp == nil){
        lastNearFPStamp = @"0";
    }
    
    if ([direction isEqualToString:@"1"]) {
        
        [client searchAroundFPWithLastTimeStamp:lastNearFPStamp Direction:direction completion:^(NSDictionary *results, NSError *error){
            if (error) {
                NSLog(@"error: %@",error);
            }else{
                if ([results[@"code"]  isEqual: @600]) {
                    
                    NSString *timeSp = [results[@"results"] firstObject][@"videoTime"];
                    lastNearFPStamp = timeSp;
                    timeSp = [results[@"results"] lastObject][@"videoTime"];
                    if([timeSp intValue] < [lastReverseNearFPStamp intValue]){
                        lastReverseNearFPStamp = timeSp;
                    }
                    completion(results[@"results"],nil);
                    
                }else{
                    NSLog(@"%@",results[@"phase"]);
                }
            }
        }];
    }else if([direction isEqualToString:@"-1"]){
        
        [client searchAroundFPWithLastTimeStamp:lastReverseNearFPStamp Direction:(NSString *)direction completion:^(NSDictionary *results, NSError *error){
            if (error) {
                NSLog(@"error: %@",error);
            }else{
                if ([results[@"code"]  isEqual: @600]) {
                    
                    NSString *timeSp = [results[@"results"] lastObject][@"videoTime"];
                    lastReverseNearFPStamp = timeSp;
                    
                    timeSp = [results[@"results"] firstObject][@"videoTime"];
                    if([timeSp intValue] >[lastNearFPStamp intValue]){
                        lastNearFPStamp = timeSp;
                    }
                    completion(results[@"results"],nil);
                }else{
                    NSLog(@"%@",results[@"phase"]);
                }
            }
        }];
    }
    
}


@end
