//
//  Location.m
//  BU Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "Location.h"

@implementation Location
@synthesize lat, lng, distance;

-(id) init {
    if (self = [super init]) {
        lat = [[NSDecimalNumber alloc]init];
        lng = [[NSDecimalNumber alloc]init];
        distance = [[NSDecimalNumber alloc]init];

    }
    return self;
}

-(id) init: (NSDecimalNumber*) lat_ : (NSDecimalNumber*) lng_ {
    if (self = [super init]) {
        lat = lat_;
        lng = lng_;
        distance = [[NSDecimalNumber alloc]init];
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *) coder
{
    [coder encodeObject:lat forKey:@"lat"];
    [coder encodeObject:lng forKey:@"lng"];
    [coder encodeObject:distance forKey:@"distance"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        lat = [decoder decodeObjectForKey:@"lat"];
        lng = [decoder decodeObjectForKey:@"lng"];
        distance = [decoder decodeObjectForKey:@"distance"];
    }
    return self;
}

@end
