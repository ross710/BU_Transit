//
//  ArrivalEstimate.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/17/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "ArrivalEstimate.h"

@implementation ArrivalEstimate
@synthesize arrival_at,stop_id,vehicle_id,vehicle_num;

-(id) init {
    if (self = [super init]) {
        arrival_at = [[NSDate alloc] init];
        vehicle_id = [[NSNumber alloc]init];
        stop_id = [[NSNumber alloc] init];
        vehicle_num = [[NSNumber alloc] init];
    }
    return self;
}

@end
