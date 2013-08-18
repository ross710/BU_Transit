//
//  Stop.h
//  BU Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Stop : NSObject <NSCoding>
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *parent_station_id;
@property (nonatomic, copy) NSArray *agency_ids;
@property (nonatomic, copy) NSString *station_id;
@property (nonatomic, copy) NSString *location_type;
@property (nonatomic, retain) Location *location;
@property (nonatomic, copy) NSNumber *stop_id;
@property (nonatomic, copy) NSArray *routes;
@property (nonatomic, copy) NSString *name;


@property (nonatomic, copy) NSString *route;


@property (nonatomic, copy) NSNumber *isInboundToStuVii;



@end
