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


- (NSURLSessionDataTask *)uploadNewFPForFP:(FootPrint *)fp fileURL:(NSURL *)fileURL completion:(void (^)(NSArray *result, NSError *error))completion{
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    NSURLSessionDataTask *task = [client POST:@"uploadFP" parameters:[fp getParam] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:fileURL.path];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        NSLog(@"%@",image);
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
        NSEnumerator *keys=[fp keyEnumerator];
        id keyInDic=nil;
        while ((keyInDic =[keys nextObject])!=nil) {
            id valueForKey=[fp objectForKey:keyInDic];
            NSLog(@"Key=%@,ValueForKey=%@",keyInDic,valueForKey);
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    return task;
}
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completion:(void (^)(NSDictionary *result, NSError *error))completion{
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:userName,@"userID",password,@"password", nil];
    [client POST:@"login" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@",error);
    }];
}
- (void)registerWithUserName:(NSString *)userName password:(NSString *)password nickName:(NSString *)nickName completion:(void (^)(NSDictionary *result, NSError *error))completion{
    
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userID",password,@"password",nickName,@"userName", nil];
    [client POST:@"registe" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
        completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
   
    
}
- (NSString *)getMD5EncodedStr:(NSString*)password {
    NSString *md5 = [[NSString alloc] initWithString:password];
    return md5;
}

@end
