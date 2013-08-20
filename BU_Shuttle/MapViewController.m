//
//  ViewController.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "MapViewController.h"
#import "BackEndWrapper.h"
#import "BusAnnotationView.h"
#import "AppDelegate.h"
#import "Stop_pin.h"

#define ZOOM_CONSTANT 5150.0

@interface MapViewController ()
@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic) NSTimer *timer;
@end

@implementation MapViewController
@synthesize mapView;
@synthesize timer;

- (void)viewDidAppear:(BOOL)animated {
    [self refreshVehicles];

    [self resumeTimer];
    NSArray *selAn = [self.mapView selectedAnnotations];
    if ([selAn count] > 0) {
        id<MKAnnotation> annotation = [selAn objectAtIndex:0];
        if ([annotation isKindOfClass:[Stop_pin class]]) {
            [self resetPressed:nil];
        }
    }
}


-(void) viewDidDisappear:(BOOL)animated {
    [self pauseTimer];
}

-(void) resumeTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector: @selector(refreshVehicles) userInfo: nil repeats: YES];
}
-(void) pauseTimer {
    [timer invalidate];
    timer = nil;
}
-(void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initEverything];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseTimer) name:@"map_active" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeTimer) name:@"map_inactive" object:nil];
    
    

}
- (IBAction)gotoListView:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"gotoListView"
     object:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) initEverything {
    mapView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).mapView;
    [self.view addSubview:mapView];

}


- (IBAction)resetPressed:(id)sender {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.34091;
    zoomLocation.longitude= -71.09682;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, ZOOM_CONSTANT, ZOOM_CONSTANT);
    //3.2
    //20
    
    // 3
    [mapView setRegion:viewRegion animated:YES];
    
    [self refreshVehicles];
}


-(void) refreshVehicles {

//    NSLog(@"REFRESHING");
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) plotVehicles];
}
@end
