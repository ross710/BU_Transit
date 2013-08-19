//
//  AWIconAnnotationView.h
//  Easy Custom Map Icons
//
//  Created by Alek Åström on 2011-08-12.
//  Copyright 2011 Apps & Wonders. No rights reserved.
//

#import <MapKit/MapKit.h>
#import "Vehicle_pin.h"


@interface BusAnnotationView : MKPinAnnotationView {
    UIImage *icon;
    UIImageView *iconView;
}
@end
