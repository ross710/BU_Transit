//influence from http://mralek.se/post/9591337792/easy-custom-mkpinannotationview-with-pin-drop
#import "StopAnnotationView.h"

@implementation StopAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {

            [self setCenterOffset:CGPointMake(0, 44)];
            [self setCalloutOffset:CGPointMake(-4.1, 20)];
            iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 24 , 24)];
        } else {
            [self setCalloutOffset:CGPointMake(-4.1, 20)];
            iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 24 , 24)];
        }
        [self addSubview:iconView];
    }
    
    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];

    icon = [UIImage imageNamed:@"icon_bus_yellow_small.png"];
    
    [iconView setImage:icon];
    [iconView setAlpha:0.8];
}


/** Override to make sure shadow image is always set
 */
- (void)setImage:(UIImage *)image {

    [super setImage:nil];

}



@end
