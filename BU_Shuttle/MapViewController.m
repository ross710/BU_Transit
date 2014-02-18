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
#import "StreetViewController.h"



#define ZOOM_CONSTANT_IOS7 5150.0
#define ZOOM_CONSTANT 4500


@interface MapViewController ()
@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic) NSTimer *timer;
@property (nonatomic, weak) AppDelegate *appDelegate;


@property (nonatomic) BOOL swap;
@end

@implementation MapViewController
@synthesize mapView;
@synthesize timer;
@synthesize appDelegate;
@synthesize shouldResetView;
@synthesize swap;

- (void)viewDidAppear:(BOOL)animated {

                       if (shouldResetView) {
                           NSArray *selAn = [self.mapView selectedAnnotations];
                           if ([selAn count] > 0) {
                               id<MKAnnotation> annotation = [selAn objectAtIndex:0];
                               if ([annotation isKindOfClass:[Stop_pin class]]) {
                                   [self resetPressed:nil];
                               }
                           }
                           shouldResetView = NO;
                           
                       }

}

-(void) showStreetView : (Stop_pin *) pin {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    StreetViewController *vc = [sb instantiateViewControllerWithIdentifier:@"streetViewController"];
    vc.location = [[CLLocation alloc] initWithLatitude:pin.coordinate.latitude longitude:pin.coordinate.longitude];
    vc.name = pin.stop_name;
    UINavigationController *navView = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navView animated:YES completion:nil];
}

-(void) viewDidDisappear:(BOOL)animated {
//    [self pauseTimer];
}

-(void) resumeTimer {
//    timer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector: @selector(refreshVehicles) userInfo: nil repeats: YES];
}
-(void) pauseTimer {
//    NSLog(@"TIMER PAUSED");
//    [timer invalidate];
//    timer = nil;
}
-(void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    appDelegate.delegate = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    swap = NO;
    [self initEverything];

    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.delegate = self;

}

- (IBAction)gotoListView:(id)sender {

//    NSLog(@"TRYING TO GO TO LIST VIEW");
    [self.delegate gotoListView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) initEverything {
    mapView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).mapView;
    [self.view addSubview:mapView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector: @selector(refreshVehicles) userInfo: nil repeats: YES];

    
}



- (IBAction)resetPressed:(id)sender {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.34091;
    zoomLocation.longitude= -71.09682;
    
    // 2
    MKCoordinateRegion viewRegion;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, ZOOM_CONSTANT_IOS7, ZOOM_CONSTANT_IOS7);
    } else {
        viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, ZOOM_CONSTANT, ZOOM_CONSTANT);
    }
    //3.2
    //20
    
    // 3
    [mapView setRegion:viewRegion animated:YES];
    
    [self refreshVehicles];

}


-(void) refreshVehicles {

    [appDelegate plotVehicles];
}
@end
