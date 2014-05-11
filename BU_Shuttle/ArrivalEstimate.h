//
//  ArrivalEstimate.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/17/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrivalEstimate : NSObject
@property (nonatomic, copy) NSDate *arrival_at;
@property (nonatomic, copy) NSNumber *vehicle_id;
@property (nonatomic, copy) NSNumber *vehicle_num;
@property (nonatomic, copy) NSNumber *stop_id;

@end
