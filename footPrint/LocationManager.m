//
//  LocationManager.m
//  footPrint
//
//  Created by apple on 2/26/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "LocationManager.h"
#import <MapKit/MapKit.h>
#import "AFNetworking.h"
#import "FPHttpClient.h"
@interface LocationManager ()

@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationBlock locationBlock;
@property(strong, nonatomic)CLGeocoder *geoCoder;

@property(nonatomic,strong)NSString *lastCity;
@property (nonatomic,strong) NSString *lastAddress;

@end
@implementation LocationManager

+(instancetype)sharedInstance{
    static LocationManager *sharedLocationManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{sharedLocationManagerInstance = [[self alloc]init];});
    return sharedLocationManagerInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        self.locaionManager = [[CLLocationManager alloc] init];
        [self.locaionManager setDelegate:self];
        [self.locaionManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
    return self;
}
- (void)getCurrentPosition:(NSStringBlock)completeHandler{
    
    self.addressBlock = [completeHandler copy];
    [self.locaionManager startUpdatingLocation];
    
}
- (void)getCurrentLocation:(LocationBlock)completeHandler{
    
    self.locationBlock = [completeHandler copy];
    [self.locaionManager startUpdatingLocation];
}



#pragma locationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *lastLocation = [locations lastObject];
    // If the location is more than 5 minutes old, ignore it
    if([lastLocation.timestamp timeIntervalSinceNow] > 300)
        return;
    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    if (accuracy < 100.0){
        self.currentLocation = lastLocation;
        NSLog(@"Current: location:%@",lastLocation);
        NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
        [defaultUser setFloat:self.currentLocation.coordinate.longitude forKey:@"FPLastLongitude"];
        [defaultUser setFloat:self.currentLocation.coordinate.latitude forKey:@"FPLastLatitude"];
        
        if (self.locationBlock) {
            self.locationBlock(self.currentLocation.coordinate);
            self.locationBlock = nil;
        }
        if (self.addressBlock) {
            
            
            double lat = self.currentLocation.coordinate.latitude;
            double lng = self.currentLocation.coordinate.longitude;
            
            NSString *url = [[NSString alloc] initWithFormat:URL_GEOCODE,lat,lng];
            FPHttpClient *client = [[FPHttpClient alloc] init];
            client.responseSerializer = [AFJSONResponseSerializer serializer];
            [client GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSArray *results = [responseObject objectForKey:@"results"];
                //NSString *status = responseObject[@"status"];
                if([results count] == 0){
                    NSLog(@"position not found");
                }
                else{
                    
                    NSDictionary *firstPlace = [results objectAtIndex:0];
                    NSDictionary *addressDict = [self extractDetailPlaceMark:firstPlace];
                    self.lastCity = addressDict[@"city"];
                    self.lastAddress = [NSString stringWithFormat:@"%@,%@",addressDict[@"country"],self.lastCity];
                    [defaultUser setObject:self.lastAddress forKey:@"FPCurrentAddress"];
                    self.addressBlock(self.lastAddress);
                    
                    self.addressBlock = nil;
                    
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@",error);
            }];
            
            /*
            self.geoCoder = [[CLGeocoder alloc] init];
            NSLog(@"currentloc: %@",self.currentLocation);
            NSLog(@"Current geoCoder: %@",self.geoCoder);
            
            [self.geoCoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks,NSError *error)
             {
                 NSLog(@"%@,%@",error,placemarks);
                 if (error && [placemarks count] == 0) {
                     NSLog(@"%@,%@",error,placemarks);
                 }
                 else{
                     
                     CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                     NSDictionary *addressDic=placeMark.addressDictionary;
                     NSString *state=[addressDic objectForKey:@"State"];
                     NSString *city=[addressDic objectForKey:@"City"];
                     NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
                     NSString *street=[addressDic objectForKey:@"Street"];
                     self.lastCity = city;
                     self.lastAddress = [NSString stringWithFormat:@"%@,%@,%@,%@",state,city,subLocality,street];
                     self.addressBlock(self.lastAddress);
                     NSLog(@"%@.....",self
                           .lastAddress);
                     [defaultUser setObject:self.lastAddress forKey:@"FPCurrentAddress"];
                     
                     self.addressBlock = nil;
                 
                 }
             }];
             */
        
        }
        
        [self.locaionManager stopUpdatingLocation];
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //TODO : ask the user  to input
    
}
- (NSDictionary *)extractDetailPlaceMark:(NSDictionary *)placeMark{
    NSMutableDictionary *addressDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    addressDic[@"formatted_address"] = [placeMark objectForKey:@"formatted_address"];
    NSArray *add_comps = [placeMark objectForKey:@"address_components"];
    for (NSDictionary *comp in add_comps) {
        if ([[comp[@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_2"]) {
            addressDic[@"city"] = comp[@"long_name"];
            break;
        }else{
            addressDic[comp[@"types"][0]] = comp[@"long_name"];
        }
    }
    return (NSDictionary *)addressDic;
}
@end
