//
//  LocationManager.h
//  footPrint
//
//  Created by apple on 2/26/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


static NSString *GECODER_API = @"http://api.map.baidu.com/geocoder/v2/?ak=cvo5aUtsm1NuUn7ObTTtQ7HR&callback=renderReverse&location=%f,%f&output=json&pois=0";
static NSString *URL_GEOCODE =@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false";

typedef void(^LocationBlock)(CLLocationCoordinate2D locationCorrrdinate);
typedef void(^NSStringBlock)(NSString *addressString);
typedef void(^NSStringBlock)(NSString *cityString);

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic)CLLocationManager *locaionManager;
@property (strong, nonatomic)CLLocation *currentLocation;

+ (instancetype)sharedInstance;
- (void)getCurrentPosition:(NSStringBlock)completeHandler;
- (void)getCurrentLocation:(LocationBlock)completeHandler;

@end
