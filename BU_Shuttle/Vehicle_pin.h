//
//  Place.h
//  Easy Custom Map Icons
//
//  Created by Alek Åström on 2011-08-12.
//  Copyright 2011 Apps & Wonders. No rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface Vehicle_pin: NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSNumber *vehicle_id;
@property (nonatomic, retain) NSNumber *heading;
@property (nonatomic, retain) NSNumber *isInboundToStuvii;

@property (nonatomic, copy) NSString *type;



- (id)initWithLong:(CGFloat)lon Lat:(CGFloat)lat vehicle_id:(NSNumber *)vehicle_id_ heading:(NSNumber *)heading_ type:(NSString *) type_;

@end
