//
//  Stop_pin.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/18/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Vehicle.h"

@interface Stop_pin: NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSString *stop_name;
@property (nonatomic, retain) NSNumber *stop_id;

//@property (nonatomic, retain) Vehicle *vehicle;



-(id)initWithLong:(CGFloat)lon : (CGFloat)lat : (NSString *) stop_name_ : (NSNumber*) stop_id_;

@end

