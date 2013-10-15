

#import <MapKit/MapKit.h>
#import "Vehicle_pin.h"


@interface BusAnnotationView : MKPinAnnotationView {
    UIImage *icon;
    UIImageView *iconView;
}

-(void) tryToUpdateIcon : (BOOL) isInboundToStuvii;
@end
