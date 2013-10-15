//influenced by http://mralek.se/post/9591337792/easy-custom-mkpinannotationview-with-pin-drop
#import "BusAnnotationView.h"


@implementation BusAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
    

        
        
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

}

-(void) tryToUpdateIcon : (BOOL) isInboundToStuvii {
    if (isInboundToStuvii) {
        icon = [UIImage imageNamed:@"icon_bus copy.png"];//
    } else {
        icon = [UIImage imageNamed:@"icon_bus MedCampus.png"];
        
    }
    [iconView setImage:icon];
//    [iconView setAlpha:0.8];

}

/** Override to make sure shadow image is always set
 */
- (void)setImage:(UIImage *)image {

    [super setImage:nil];

}



@end
