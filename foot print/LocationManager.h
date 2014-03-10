//
//  LocationManager.h
//  footPrint
//
//  Created by apple on 2/26/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic)CLLocationManager *locaionManager;
@property (strong, nonatomic)CLLocation *currentPosition;

+ (instancetype)sharedInstance;
- (NSString *)getCurrentPosition;
- (CLLocation *)getCurrentLocation;
@end
