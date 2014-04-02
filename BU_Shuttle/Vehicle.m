//
//  Vechicle.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "Vehicle.h"

@implementation Vehicle
@synthesize heading, location, tracking_status, vehicle_id, type, arrival_estimates, call_name, vehicle_num;

-(id) init {
    if (self = [super init]) {
        arrival_estimates = [[NSArray alloc]init];
        call_name = [[NSNumber alloc] init];
        heading = [[NSNumber alloc]init];
        location = [[Location alloc]init];
        tracking_status = [[NSString alloc]init];
        vehicle_id = [[NSNumber alloc]init];
        type = [[NSString alloc]init];
        vehicle_num = [[NSNumber alloc] init];
    }
    return self;
}





@end
