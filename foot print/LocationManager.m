//
//  LocationManager.m
//  footPrint
//
//  Created by apple on 2/26/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "LocationManager.h"
#import "AddressReverseGeoder.h"

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
- (NSString* )getCurrentPosition{
    [self.locaionManager startUpdatingLocation];
    AddressReverseGeoder *reverseCoder = [[AddressReverseGeoder alloc] init];
    NSString *a = [reverseCoder startReverseGeoderWithLatitude:self.currentPosition];
    return a;
}
- (CLLocation *)getCurrentLocation{
    if (self.currentPosition ==nil) {
        [self.locaionManager startUpdatingLocation];
    }
    return self.currentPosition;
}



#pragma locationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *lastLocation = [locations lastObject];
    // If the location is more than 5 minutes old, ignore it
    if([lastLocation.timestamp timeIntervalSinceNow] > 300)
        return;
    
    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    NSLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
    
    if (accuracy < 100.0){
        self.currentPosition = lastLocation;
        [self.locaionManager stopUpdatingLocation];
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //TODO : ask the user  to input
    
}


@end
