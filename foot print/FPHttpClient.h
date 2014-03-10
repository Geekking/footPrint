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
static NSString *baseServerURLString = @"http://127.0.0.1:3000/";

@interface FPHttpClient : AFHTTPSessionManager
+ (FPHttpClient *)sharedHttpClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (NSURLSessionDataTask *)uploadNewFPForFP:(FootPrint *)fp fileURL:(NSURL *)fileURL completion:( void (^)(NSArray *results, NSError *error) )completion;

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completion:(void (^)(NSDictionary *result, NSError *error))completion;
- (void)registerWithUserName:(NSString *)usrName password:(NSString *)password nickName:(NSString *)nickName completion:(void (^)(NSDictionary *result, NSError *error))completion;
@end
