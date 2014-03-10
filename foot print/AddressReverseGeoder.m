//
//  AddressReverseGeoder.m
//  footPrint
//
//  Created by apple on 2/25/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "AddressReverseGeoder.h"


@implementation AddressReverseGeoder
#pragma mark --
#pragma mark geocoder

+(instancetype)sharedInstance{
    static AddressReverseGeoder *sharedAddressReverseGeoderInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{sharedAddressReverseGeoderInstance = [[self alloc]init];});
    return sharedAddressReverseGeoderInstance;
}

- (NSString *)startReverseGeoderWithLatitude:(CLLocation *)location {
    if (!self.geoCoder) {
        self.geoCoder = [[CLGeocoder alloc]init];
    }
    NSString *currentPlace;
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0)
        {
            //TODO: get current position
        }
        //TODO: handle error
    }];
    return currentPlace;
}

@end
