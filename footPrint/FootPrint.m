//
//  FootPrint.m
//  footPrint
//
//  Created by apple on 2/27/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "FootPrint.h"
#import "LocationManager.h"

@implementation FootPrint
- (id)initWithDescription:(NSString*)description coverImage:(UIImage *)coverImage currentPosition:(NSString *)currentPosition informUserList:(NSArray *)informedUserList secureType:(SecureType) secureType videoURL:(NSURL *)videoURL{
    self = [super init];
    if (self){
        self.info = [[NSMutableDictionary alloc] init];
        
        [[self getInfo] setValue:description forKey:@"description"];
        [[self getInfo] setValue:coverImage forKey:@"coverImage"];
        
        [[self getInfo] setValue:currentPosition forKey:@"position"];
        
        if (informedUserList) {
            [self setValue:informedUserList forKey:@"informUserList"];
        }
        //[self setValue:secureType forKey:@"secureType"];
        [[self getInfo] setValue:[self getCurrentTime] forKey:@"videoTime"];
        NSUserDefaults *standardUser = [NSUserDefaults standardUserDefaults];
        
        __block NSString *locationStr = [NSString stringWithFormat:@"%f,%f",[standardUser floatForKey:@"FPLastLatitude"],[standardUser floatForKey:@"FPLastLongitude"]];
        
        [[LocationManager sharedInstance] getCurrentLocation:^(CLLocationCoordinate2D locationCorrrdinate) {
            locationStr = [self LocationToString:locationCorrrdinate];
        }];
        
        [[self getInfo] setValue:locationStr forKey:@"location"];
        [[self getInfo] setValue:videoURL forKey:@"localURL"];
    }
    return self;
}
- (id)initWithDictionary:(NSDictionary *)fpdict{
    self = [super init];
    if(self )
    {
        self.info = [[NSMutableDictionary alloc] initWithDictionary:fpdict];
        
    }
    return self;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    self.info[key] = value;
}
- (NSString *)LocationToString:(CLLocationCoordinate2D )location{
    NSString *strLoc = [NSString stringWithFormat:@"%f,%f",location.latitude,location.longitude];
    return strLoc;
}

- (NSMutableDictionary *)getInfo{
    return  self.info;
}
- (NSString *)getCurrentTime{
    NSDate *localDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];
    return timeSp;
}
- (UIImage *)getImage{
    return  [self.info objectForKey:@"coverImage"];
}
- (void)setCoverImage:(UIImage *)coverImage{
    [self.info setObject:coverImage forKey:@"coverImage"];
}
- (NSURL *)getFileURL{
    return [self.info objectForKey:@"localURL"];
}
- (NSDictionary *)Stringify{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:self.description forKey:@"position"];
    return  data;
}
- (NSDictionary *)getParam{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *infromUserStr = [[NSString alloc] init];
    if (self.info[@"informUserList"]) {
        for (int i=0; i<[self.info[@"informUserList"] count]; i++) {
            NSString *str = [self.info[@"informUserList"] objectAtIndex:i];
            if ([infromUserStr length] >0) {
                infromUserStr = [infromUserStr stringByAppendingString:@","];
           
            }
            infromUserStr = [infromUserStr stringByAppendingString:str];
        }
        
    }
    NSDictionary *para = [[NSDictionary alloc] initWithObjectsAndKeys:[defaults objectForKey:@"userID"],@"userID",self.info[@"description"],@"description",self.info[@"videoTime"],@"videoTime",self.info[@"location"],@"coordinate",self.info[@"position"],@"position",infromUserStr,@"informUserList",nil];
    return para;
}
@end
