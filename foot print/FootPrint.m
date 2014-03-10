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
        [self setValue:description forKey:@"description"];
        [self setValue:coverImage forKey:@"coverImage"];
        [self setValue:currentPosition forKey:@"position"];
        
        [self setValue:informedUserList forKey:@"informUserList"];
        //[self setValue:secureType forKey:@"secureType"];
        [self setValue:[self getCurrentTime] forKey:@"videoTime"];
        [self setValue:[self LocationToString:[[LocationManager sharedInstance] getCurrentLocation]] forKey:@"location"];
        [self setValue:videoURL forKey:@"localURL"];
    }
    return self;
}
- (NSString *)LocationToString:(CLLocation *)location{
    NSString *strLoc = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    return strLoc;
}
- (NSString *)getCurrentTime{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSDate *curDate = [NSDate date];
    NSString *strCurTime = [formater stringFromDate:curDate];
    return strCurTime;
}
- (UIImage *)getImage{
    return  [self objectForKey:@"coverImage"];
}
- (NSURL *)getFileURL{
    return [self objectForKey:@"localURL"];
}
- (NSDictionary *)Stringify{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:self.description forKey:@"position"];
    return  data;
}
- (NSDictionary *)getParam{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *para = [[NSDictionary alloc] initWithObjectsAndKeys:[defaults objectForKey:@"userID"],@"userID",self[@"description"],@"description",self[@"position"],@"position",self[@"videoTime"],@"videoTime",self[@"location"],@"location",nil];
    return para;
}
@end
