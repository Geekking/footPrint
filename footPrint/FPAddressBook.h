//
//  FPAddressBook.h
//  footprint
//
//  Created by apple on 3/12/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPAddressBook : NSObject{
    NSInteger sectionNumber;
    NSInteger recordID;
    NSString *name;
    NSString *email;
    NSString *tel;
}
@property NSInteger sectionNumber;
@property NSInteger recordID;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *email;
@property (strong, nonatomic)NSString *tel;


@end
