//
//  AWIconAnnotationView.m
//  Easy Custom Map Icons
//
//  Created by Alek Åström on 2011-08-12.
//  Copyright 2011 Apps & Wonders. No rights reserved.
//

#import "BusAnnotationView.h"


@implementation BusAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        // Compensate frame a bit so everything's aligned
//        [self setCenterOffset:CGPointMake(-9, -3)];
//        [self setCalloutOffset:CGPointMake(-2, 3)];
//        
//        // Add the pin icon
//        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 32, 37)];
        
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(-8 , 0, 32 , 32)];

        
        [self addSubview:iconView];
    }
    
    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    
    Vehicle_pin *pin = (Vehicle_pin *)annotation;
    BOOL isInboundToStuvii = [pin.isInboundToStuvii boolValue];
    if (isInboundToStuvii) {
        icon = [UIImage imageNamed:@"icon_bus copy.png"];//[NSString stringWithFormat:@"pin_%d.png", [place.icon intValue]]];
    } else {
        icon = [UIImage imageNamed:@"icon_bus MedCampus.png"];

    }
    [iconView setImage:icon];
//    [iconView setAlpha:0.8];

}

-(void) tryToUpdateIcon : (BOOL) isInboundToStuvii {
    if (isInboundToStuvii) {
        icon = [UIImage imageNamed:@"icon_bus copy.png"];//[NSString stringWithFormat:@"pin_%d.png", [place.icon intValue]]];
    } else {
        icon = [UIImage imageNamed:@"icon_bus MedCampus.png"];
        
    }
    [iconView setImage:icon];
//    [iconView setAlpha:0.8];

}

/** Override to make sure shadow image is always set
 */
- (void)setImage:(UIImage *)image {
//    [super setImage:[UIImage imageNamed:@"pin_shadow.png"]];
    [super setImage:nil];
//    [super setImage:[UIImage imageNamed:@"icon_bus shadow.png"]];
}



@end
