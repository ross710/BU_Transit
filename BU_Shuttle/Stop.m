//
//  Stop.m
//  BU Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "Stop.h"

@implementation Stop
@synthesize code,description,url,parent_station_id,agency_ids,station_id,location_type,location,stop_id,routes,name, route, isInboundToStuVii;

-(id) init {
    if (self = [super init]) {
        location = [[Location alloc]init];
        name = [[NSString alloc]init];
        route = [[NSString alloc]init];
        routes = [[NSArray alloc] init];
        stop_id = [[NSNumber alloc] init];
        isInboundToStuVii = [[NSNumber alloc] initWithBool:NO];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *) coder
{
    [coder encodeObject:location forKey:@"location"];
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:route forKey:@"route"];
     [coder encodeObject:routes forKey:@"routes"];
    [coder encodeObject:stop_id forKey:@"stop_id"];
    [coder encodeObject:isInboundToStuVii forKey:@"isInboundToStuVii"];


}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        location = [decoder decodeObjectForKey:@"location"];
        name = [decoder decodeObjectForKey:@"name"];
        routes = [decoder decodeObjectForKey:@"routes"];
        route = [decoder decodeObjectForKey:@"route"];

        stop_id = [decoder decodeObjectForKey:@"stop_id"];
        isInboundToStuVii = [decoder decodeObjectForKey:@"isInboundToStuVii"];

    }
    return self;
}


@end
