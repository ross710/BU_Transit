//
//  Place.m
//  Easy Custom Map Icons
//
//  Created by Alek Åström on 2011-08-12.
//  Copyright 2011 Apps & Wonders. No rights reserved.
//

#import "Vehicle_pin.h"

@implementation Vehicle_pin
@synthesize coordinate, vehicle_id, heading, type, isInboundToStuvii;

- (id)initWithLong:(CGFloat)lon Lat:(CGFloat)lat vehicle_id:(NSNumber *)vehicle_id_ heading:(NSNumber *)heading_ type:(NSString *) type_ {
    self = [super init];
    if (self) {
        coordinate = CLLocationCoordinate2DMake(lat, lon);
        self.vehicle_id = vehicle_id_;
        self.heading = heading_;
        self.type = type_;
        self.isInboundToStuvii = [NSNumber numberWithBool:NO];
        
    }
    
    return self;
}

-(void) setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    [self willChangeValueForKey:@"coordinate"];
    coordinate = newCoordinate;
    [self didChangeValueForKey:@"coordinate"];

}
- (NSString *)title {
    return [NSString stringWithFormat:@"%@", self.type];
}

- (NSString *)subtitle {
    return [NSString stringWithFormat:@"ID: %@", self.vehicle_id];
}


@end
