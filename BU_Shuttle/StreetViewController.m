//
//  StreetViewController.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/20/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "StreetViewController.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * 180.0 / M_PI)


@interface StreetViewController ()

@end

@implementation StreetViewController {
    GMSPanoramaView *panoView_;
}
@synthesize location;
@synthesize name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
 
    [[self navigationItem] setTitle:name];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissStreetView)];
    [[self navigationItem] setLeftBarButtonItem:button];
    
    UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indView setCenter:CGPointMake(([UIScreen mainScreen].bounds.size.width)/2, ([UIScreen mainScreen].bounds.size.height)/2)];
    [indView startAnimating];
    [self.view addSubview:indView];
}
-(void) dismissStreetView {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//Adapted from http://stackoverflow.com/questions/17829611/how-to-draw-an-arrow-between-two-points-on-the-map-mapkit
-(CGFloat) calculateUserAngle:(CLLocationCoordinate2D)first :(CLLocationCoordinate2D) second {
    double x = 0, y = 0 , deg = 0,delLon = 0;
    
    
    delLon = second.longitude - first.longitude;
    y = sin(delLon) * cos(second.latitude);
    x = cos(first.latitude) * sin(second.latitude) - sin(first.latitude) * cos(second.latitude) * cos(delLon);
    deg = RADIANS_TO_DEGREES(atan2(y, x));
    
    if(deg<0){
        deg = -deg;
    } else {
        deg = 360 - deg;
    }

    return deg;
}


-(void) viewDidAppear:(BOOL)animated {
    GMSMarker *marker = [GMSMarker markerWithPosition:location.coordinate];
    panoView_ = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
    [panoView_ moveNearCoordinate:location.coordinate];
    marker.panoramaView = panoView_;

    CGFloat heading = [self calculateUserAngle:panoView_.panorama.coordinate :marker.position];

    GMSPanoramaCamera *camera = [GMSPanoramaCamera cameraWithHeading:heading pitch:0 zoom:0];

    [panoView_ animateToCamera:camera animationDuration:0];

    self.view = panoView_;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
