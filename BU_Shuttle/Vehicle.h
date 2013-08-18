//
//  Vechicle.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Vehicle : NSObject
@property (nonatomic, copy) NSArray *arrival_estimates;
@property (nonatomic, copy) NSNumber *call_name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSNumber *heading;
@property (nonatomic, copy) NSString *last_updated_on;
@property (nonatomic, retain) Location *location;
@property (nonatomic, copy) NSNumber *route_id;
@property (nonatomic, copy) NSString *segment_id;
@property (nonatomic, copy) NSDecimalNumber *speed;
@property (nonatomic, copy) NSString *tracking_status; //check
@property (nonatomic, copy) NSNumber *vehicle_id;
@property (nonatomic, copy) NSString *type;

@end
