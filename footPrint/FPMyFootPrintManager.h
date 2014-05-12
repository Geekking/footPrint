//
//  FPMyFootPrintManager.h
//  footprint
//
//  Created by apple on 3/17/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "FPHttpClient.h"
#include "FootPrint.h"
#define  kNumberOfFpsInaPage 10

@interface FPMyFootPrintManager : NSObject

@property (nonatomic)NSInteger lastFPID;

+ (FPMyFootPrintManager *) sharedInstance;

- (NSMutableArray *)fetchCurrentFootPrintsInPages:(NSInteger )page;

- (BOOL)insertNewUploadingFPIntoDB:(FootPrint *)fp;

- (NSMutableArray *)fetchUpdatingFPs;

@end

