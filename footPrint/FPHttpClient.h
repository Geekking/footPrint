//
//  FPHttpClient.h
//  footPrint
//
//  Created by apple on 3/2/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "FootPrint.h"
static NSString *baseServerURLString = @"http://172.18.156.90:3000/";

@interface FPHttpClient : AFHTTPSessionManager
+ (FPHttpClient *)sharedHttpClient;
+ (NSString *)getBaseURL;
- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completion:(void (^)(NSDictionary *result, NSError *error))completion;
- (void)registerWithUserName:(NSString *)usrName password:(NSString *)password nickName:(NSString *)nickName completion:(void (^)(NSDictionary *result, NSError *error))completion;
@end

@interface FPHttpClient (FootPrint)
- (NSURLSessionDataTask *)uploadNewFPForFP:(FootPrint *)fp fileURL:(NSURL *)fileURL completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (void)refreshFootPrintWithLastFpID:(NSString *)fpID completion:( void (^)(NSDictionary *results, NSError *error) )completion;
@end

@interface FPHttpClient (MyFriends)
- (void)lookForNewFriendsWithFriendID:(NSString *)friendID completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (void)addNewFriendsWithFriendID:(NSString *)fiendID completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (void)refreshFriendsWithLastTimeStamp:(NSString *)lastFrendsStmp completion:( void (^)(NSDictionary *results, NSError *error) )completion;
@end

@interface FPHttpClient (AroundMe)

/*@ param lastTimeStamp
 *@ param completion completion block
 *@ return none
 */
- (void)searchAroundFPWithLastTimeStamp:(NSString *)lastTimeStamp Direction:(NSString *)direction completion:( void (^)(NSDictionary *results, NSError *error) )completion;

@end

@interface FPHttpClient (Comment)


- (void)getCommentOfFP:(NSUInteger )fpID completion:( void (^)(NSDictionary *results, NSError *error) )completion;

- (void)commentOnFP:(NSUInteger)fpID comentContent:(NSString *)content completion:( void (^)(NSDictionary *results, NSError *error) )completion;


@end


@interface FPHttpClient (More)

- (void)getPersonInfo:(NSString *)queryuserID completion:(void (^)(NSDictionary *results,NSError *error))completion;



@end

