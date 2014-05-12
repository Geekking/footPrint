
//
//  FPHttpClient.m
//  footPrint
//
//  Created by apple on 3/2/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "FPHttpClient.h"

@implementation FPHttpClient
+ (FPHttpClient *)sharedHttpClient
{
    static FPHttpClient *_sharedFPHttpClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFPHttpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseServerURLString]];
    });
    
    return _sharedFPHttpClient;
}
+ (NSString *)getBaseURL{
    return baseServerURLString;
}
- (instancetype)initWithBaseURL:(NSURL *)url{
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    [conf setHTTPAdditionalHeaders:@{@"User-Agent":@"FP 1.0"}];
    self = [super initWithBaseURL:url sessionConfiguration:conf];
    
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}


- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completion:(void (^)(NSDictionary *result, NSError *error))completion{
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:userName,@"userID",password,@"password", nil];
    [client POST:@"login" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@",error);
        completion(nil,error);
    }];
}
- (void)registerWithUserName:(NSString *)userName password:(NSString *)password nickName:(NSString *)nickName completion:(void (^)(NSDictionary *result, NSError *error))completion{
    
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userID",password,@"password",nickName,@"nickName", nil];
    [client POST:@"registe" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil,error);
    }];
    
    
   
    
}
- (NSString *)getMD5EncodedStr:(NSString*)password {
    NSString *md5 = [[NSString alloc] initWithString:password];
    return md5;
}

@end

@implementation FPHttpClient (FootPrint)

- (NSURLSessionDataTask *)uploadNewFPForFP:(FootPrint *)fp fileURL:(NSURL *)fileURL completion:(void (^)(NSDictionary *result, NSError *error))completion{
    
    NSURLSessionDataTask *task = [self POST:@"postFP" parameters:[fp getParam] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if ([fileURL.pathExtension isEqualToString:@"jpg"]) {
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:fileURL.path];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpeg" mimeType:@"image/jpeg"];

        }else if([fileURL.pathExtension isEqualToString:@"MOV"]) {
            NSData *movieDate = [[NSData alloc] initWithContentsOfURL:fileURL];
            [formData appendPartWithFileData:movieDate name:@"movie" fileName:@"movie.mov" mimeType:@"video/quicktime"];
            UIImage *image = [fp getImage];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"image" mimeType:@"image/jpeg"];
        }else{
            NSLog(@"%@",fileURL.pathExtension);
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    return task;
}
- (void)refreshFootPrintWithLastFpID:(NSString *)fpID completion:(void (^)(NSDictionary *, NSError *))completion{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:[defaultUser objectForKey:@"userID"],@"userID",fpID,@"lastFPID",nil];
    
    [self POST:@"refreshFP" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        completion(nil,error);
    }];
}

@end

@implementation FPHttpClient (MyFriends)

- (void)lookForNewFriendsWithFriendID:(NSString *)friendID completion:( void (^)(NSDictionary *results, NSError *error) )completion{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:[defaultUser objectForKey:@"userID"],@"userID",friendID,@"aimedUserID",nil];
    
    [self POST:@"findUser" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"NETWORK error,%@",error);
        completion(nil,error);
    }];
    
}
- (void)addNewFriendsWithFriendID:(NSString *)fiendID completion:( void (^)(NSDictionary *results, NSError *error) )completion{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:[defaultUser objectForKey:@"userID"],@"userID",fiendID,@"aimedUserID",nil];
    NSLog(@"%@",info);
    
    [self POST:@"addFriend" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"add response");
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"NETWORK error,%@",error);
        completion(nil,error);
    }];
}
-(void)refreshFriendsWithLastTimeStamp:(NSString *)lastFrendsStmp completion:(void (^)(NSDictionary *, NSError *))completion{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:[defaultUser objectForKey:@"userID"],@"userID",lastFrendsStmp,@"lastFriendStamp",nil];
    NSLog(@"%@",info);
    [self POST:@"getFriends" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"refresh response");
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"NETWORK error,%@",error);
        completion(nil,error);
    }];
}

@end
#import "LocationManager.h"

@implementation FPHttpClient (AroundMe)
- (void)searchAroundFPWithLastTimeStamp:(NSString *)lastTimeStamp Direction:(NSString *)direction completion:(void (^)(NSDictionary *, NSError *))completion{
    
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    if (direction == nil) {
        direction = @"1";
    }
    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[defaultUser objectForKey:@"userID"],@"userID",lastTimeStamp,@"requestTimestamp",direction, @"direction",nil];
    
    [[LocationManager sharedInstance] getCurrentLocation:^(CLLocationCoordinate2D locationCorrrdinate) {
        NSString *curLoc = [NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
        [info setObject:curLoc forKey:@"location"];
        [self POST:@"searchNearFP" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
            completion(responseObject,nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"search near fp error: %@",error);
            completion(nil,error);
        }];
    }];
}

@end

@implementation FPHttpClient (Comment)

- (void)getCommentOfFP:(NSUInteger)fpID completion:(void (^)(NSDictionary *, NSError *))completion{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[defaultUser objectForKey:@"userID"],@"userID",fpID,@"queryFPID",nil];
    [self POST:@"getCommentOfFP" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
            completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"search near fp error: %@",error);
        completion(nil,error);
    }];
    
}

- (void)commentOnFP:(NSUInteger)fpID comentContent:(NSString *)content completion:(void (^)(NSDictionary *, NSError *))completion{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSDate *localDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];
    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 [defaultUser objectForKey:@"userID"],@"commentUserID",fpID,@"FPID",timeSp,@"commentTime",content, @"commentContent",nil];
    [[LocationManager sharedInstance] getCurrentLocation:^(CLLocationCoordinate2D locationCorrrdinate) {
        NSString *curLoc = [NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
        [info setObject:curLoc forKey:@"commentLocation"];
        [self POST:@"commentOnFP" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
            completion(responseObject,nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"commentfp error: %@",error);
            completion(nil,error);
        }];
    }];

}
@end

@implementation FPHttpClient (More)
- (void)getPersonInfo:(NSString *)queryuserID completion:(void (^)(NSDictionary *, NSError *))completion{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSDictionary *para = [[NSDictionary alloc] initWithObjectsAndKeys:[defaultUser objectForKey:@"userID"],@"userID",queryuserID,@"queryuserID", nil];
    [self POST:@"getPersonInfo" parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"get person info error: %@",error);
    }];
    
    
}

@end
