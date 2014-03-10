//
//  AddressReverseGeoder.h
//  footPrint
//
//  Created by apple on 2/25/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface AddressReverseGeoder : NSObject
@property(strong, nonatomic)CLGeocoder *geoCoder;

+ (instancetype)sharedInstance;
- (NSString *)startReverseGeoderWithLatitude:(CLLocation *)location;

@end
