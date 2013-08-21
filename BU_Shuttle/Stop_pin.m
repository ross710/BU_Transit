//
//  Stop_pin.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/18/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "Stop_pin.h"

@implementation Stop_pin
@synthesize stop_name, coordinate, stop_id;


-(id)initWithLong:(CGFloat)lon :(CGFloat)lat : (NSString *) stop_name_ : (NSNumber *) stop_id_{
    self = [super init];
    if (self) {
        coordinate = CLLocationCoordinate2DMake(lat, lon);
        stop_name = stop_name_;
        stop_id = stop_id_;
    }
    
    return self;
}

- (NSString *)title {
    return [NSString stringWithFormat:@"%@", stop_name];
}

- (NSString *)subtitle {
    return @"Touch for street view";
    return  nil;
//    return [NSString stringWithFormat:@"Next_bus: %@", [vehicle.arrival_estimates objectAtIndex:0]  ];
}


@end
