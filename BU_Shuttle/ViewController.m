//
//  ViewController.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "ViewController.h"
#import "BackEndWrapper.h"
#import "AWIconAnnotationView.h"
#import "AppDelegate.h"

#define METERS_PER_MILE 1609.344

@interface ViewController ()

@end

@implementation ViewController
@synthesize stops, vehicles;
@synthesize mapView;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;





- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude =
    42.34091;
    zoomLocation.longitude= -71.09682;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 3.2*METERS_PER_MILE, 3.2*METERS_PER_MILE);
    //3.2
    //20
    
    // 3
    [mapView setRegion:viewRegion animated:YES];
}




- (void) saveStops
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0];
//    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Stops.plist"];
//    
//    // read property list into memory as an NSData object
//    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
//    NSString *errorDesc = nil;
//    NSPropertyListFormat format;
//    // convert static property liost into dictionary object
//    NSMutableDictionary *plistDict = (NSMutableDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
//    if (!plistDict)
//    {
//        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
//        plistDict = [[NSMutableDictionary alloc]init];
//    }
//    
//    if ([plistDict objectForKey:@"stops"] ==  NULL) {
//        NSDictionary *newData = [NSDictionary dictionaryWithObjectsAndKeys:stops, @"stops", nil];
//        [plistDict addEntriesFromDictionary:newData];
//        NSString *error = nil;
//        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
//        
//        
//        // check is plistData exists
//        if(plistData)
//        {
//            [plistData writeToFile:plistPath atomically:YES];
//        }
//        else
//        {
//            NSLog(@"Error in saveData: %@", error);
//        }
//        NSLog(@"New User");
//    } else {
//        NSLog(@"Existing User");
//    }
    
}

//-(NSUInteger) closestStop: (NSMutableArray *) stops_ {
//    NSDecimalNumber *smallestDistance = [[NSDecimalNumber alloc] initWithDouble:0];
//    NSUInteger closest;
//
//    NSUInteger count = 0;
//    for (id object in stops_) {
//        
//        Stop *stop = (Stop *) object;
//        NSDecimalNumber *distance = [self calculateDistance:stop.location];
//        if ([smallestDistance isEqualToNumber:[[NSNumber alloc] initWithInt:0]]
//            || [smallestDistance doubleValue] > [distance doubleValue]) {
//            smallestDistance = distance;
//            closest = count;
////            NSLog(@"distance %@", distance);
//        }
//        count++;
//    }
//    return closest;
//}
//
////returns two closest
//-(NSArray *) closestStops {
//    Stop *stop1, *stop2;
//    
//    NSMutableArray *mut = [stops mutableCopy];
//    NSUInteger firstIndex = [self closestStop:mut];
//    stop1 = [stops objectAtIndex:firstIndex];
//    
//    [mut removeObjectAtIndex:firstIndex];
//    stop2 = [mut objectAtIndex:[self closestStop:mut]];
//    
//    return [NSArray arrayWithObjects: stop1, stop2, nil];
//}
//
//
//-(NSUInteger) closestVehicle: (NSMutableArray *) vehicles_ {
//    NSDecimalNumber *smallestDistance = [[NSDecimalNumber alloc] initWithDouble:0];
//    NSUInteger closest;
//    
//    NSUInteger count = 0;
//    for (id object in vehicles_) {
//        
//        Vechicle *vehicle = (Vechicle *) object;
//        NSDecimalNumber *distance = [self calculateDistance:vehicle.location];
//        if ([smallestDistance isEqualToNumber:[[NSNumber alloc] initWithInt:0]]
//            || [smallestDistance doubleValue] > [distance doubleValue]) {
//            smallestDistance = distance;
//            closest = count;
//            //            NSLog(@"distance %@", distance);
//        }
//        count++;
//    }
//    return closest;
//}
//
////returns two closest
//-(NSArray *) closestVehicles {
//    Vechicle *vehicle1, *vehicle2;
//    
//    NSMutableArray *mut = [vehicles mutableCopy];
//    NSUInteger firstIndex = [self closestVehicle:mut];
//    vehicle1 = [vehicles objectAtIndex:firstIndex];
//
//    [mut removeObjectAtIndex:firstIndex];
//    vehicle2 = [mut objectAtIndex:[self closestVehicle:mut]];
//    
//    return [NSArray arrayWithObjects: vehicle1, vehicle2, nil];
//}
//
//
//-(NSDecimalNumber *) calculateDistance: (Location *) loc{
//    CLLocation *destination = [[CLLocation alloc] initWithLatitude:[loc.lat doubleValue] longitude:[loc.lng doubleValue]];
//    
//    //now convert to miles
//    NSDecimalNumber *distance = [[NSDecimalNumber alloc] initWithDouble:[destination distanceFromLocation:myLocation] * 0.000621371192];
//    
//    NSLog (@"Distance %@", distance);
//    return distance;
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initEverything];
    
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


-(void) dealloc {
    mapView.delegate = nil;
}

-(void) viewDidUnload {
    mapView.delegate = nil;
}

-(void) initEverything {
    
    mapView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).mapView;
    [self.view addSubview:mapView];
    mapView.delegate = self;
    
    BackEndWrapper *wrapper = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).wrapper;
    NSString *json = [wrapper getJsonStringVehicles];
    [wrapper loadVehiclesIntoObjects:json];
    
    vehicles = wrapper.vehicles;
    [self plotVehicles];
//
//    
    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector: @selector(refreshPressed:) userInfo: nil repeats: YES];
//    json = [wrapper getJsonStringArrivalEstimates];
//    [wrapper loadArrivalEstimatesIntoObjects:json];
    
    
//    stops = [[NSMutableArray alloc] init];
//    vehicles = [[NSMutableArray alloc] init];
//    [self initLocation];
//    myLocation = locationManager.location;
//    
//    NSString *stopsJson = [self getJsonStringStops];
//    [self loadStopsIntoObjects:stopsJson];
//    
//    
//    
////    NSArray *closestStops = [self closestStops];
////    Stop *stop1 = [closestStops objectAtIndex:0];
////    Stop *stop2 = [closestStops objectAtIndex:1];
////
////    stop_1.text = stop1.name;
////    stop_2.text = stop2.name;
//    
//    NSString *vehiclesJson = [self getJsonStringVehicles];
//
//    [self loadVehiclesIntoObjects:vehiclesJson];
//    
//    [self plotVehicles];

    
    
//    NSArray *closestVehicles = [self closestVehicles];
//    Vechicle *vehicle1 = [closestVehicles objectAtIndex:0];
//    Vechicle *vehicle2 = [closestVehicles objectAtIndex:1];
//    
//    
//    NSDecimalNumber *dist1 = [self calculateDistance:vehicle1.location];
//    NSDecimalNumber *dist2 = [self calculateDistance:vehicle2.location];
//
//    vehicle_1.text = [NSString stringWithFormat:@"%1.1F", [dist1 doubleValue]];
//    vehicle_2.text = [NSString stringWithFormat:@"%1.1F", [dist2 doubleValue]];
//    NSLog(@"1st %@", stop1.name);
//    NSLog(@"2nd %@", stop2.name);
}



-(void) zoomInOnRoute
{
	[self.mapView setVisibleMapRect:_routeRect];
}


- (IBAction)refreshPressed:(id)sender {
    BackEndWrapper *wrapper = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).wrapper;
    NSString *json = [wrapper getJsonStringVehicles];
    [wrapper loadVehiclesIntoObjects:json];
    
    vehicles = wrapper.vehicles;
    [self plotVehicles];
    
}
//
//-(void) initLocation {
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
//}
//
//- (NSString *)deviceLocation {
//    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
//    return theLocation;
//}
//
- (void)plotVehicles {
    BOOL alreadyInit = NO;
    for (Vehicle_pin<MKAnnotation> *annotation in mapView.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            alreadyInit = YES;
            
            Vehicle *vehicle = [vehicles objectForKey:annotation.vehicle_id];
            if (vehicle) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake([vehicle.location.lat doubleValue],[vehicle.location.lng doubleValue]);
                [annotation setCoordinate:coord];
                [UIView commitAnimations];
            }
        }
    }
    
    if (!alreadyInit) {
        for (id key in vehicles) {
            Vehicle *vehicle = [vehicles objectForKey:key];
//            Vehicle_pin *annotation = [[Vehicle_pin alloc] initWithLong:[vehicle.location.lng doubleValue] Lat:[vehicle.location.lat doubleValue] vehicle_id:vehicle.vehicle_id heading:vehicle.heading type:vehicle.type];
            Vehicle_pin *annotation = [[Vehicle_pin alloc] initWithLong:[vehicle.location.lng doubleValue] Lat:[vehicle.location.lat doubleValue] vehicle_id:vehicle.call_name heading:vehicle.heading type:vehicle.type];
            if ([vehicle.arrival_estimates count] > 0) {
                NSDictionary *dict = [vehicle.arrival_estimates objectAtIndex:0];

                annotation.isInboundToStuvii = [NSNumber numberWithBool:[self isInboundToStuvii:[dict objectForKey:@"stop_id"]]];
            }
            [mapView addAnnotation:annotation];
        }
    }


}

-(BOOL) isInboundToStuvii : (NSNumber *) stopId{
    NSInteger stop_id = [stopId integerValue];
    switch (stop_id) {
        case 4068466: //ST. Mary's
            return NO;
            break;
        case 4068470: //Blanford
            return NO;
            break;
        case 4068478: //Huntington EastBound
            return NO;
            break;
        case 4068482: //710 Albany
            return NO;
            break;
        case 4068502: //Myles Standish
            return YES;
            break;
        case 4068514: //Marsh Plaza
            return YES;
            break;
        case 4108734: //518 Park Dr (South Campus)
            return NO;
            break;
        case 4108738: //Granby St
            return NO;
            break;
        case 4108742: //GSU
            return YES;
            break;
        case 4110206: //Kenmore
            return NO;
            break;
        case 4110214: //CFA
            return YES;
            break;
        case 4114006: //Agganis Way
            return YES;
            break;
        case 4114010: //Danielsen Hall
            return YES;
            break;
        case 4114014: //Silber Way
            return YES;
            break;
        case 4117694: //815 Albany
            return YES;
            break;
        case 4117698: //Amory St
            return NO;
            break;
        case 4117702: //Huntington Westbound
            return YES;
            break;
        case 4117706: //StuVii (10 Buick St)
            return NO;
            break;
        case 4117710: //StuVii2
            return NO;
            break;
        default:
            return NO;
            break;
    }
}



#pragma mark - Map view delegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now.
		if(nil == self.routeLineView)
		{
			self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
			self.routeLineView.fillColor = [UIColor redColor];
			self.routeLineView.strokeColor = [UIColor redColor];
			self.routeLineView.lineWidth = 3;
		}
		
		overlayView = self.routeLineView;
		
	}
	
	return overlayView;
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (annotation == aMapView.userLocation) {
        return nil; // Let map view handle user location annotation
    }
    
    // Identifyer for reusing annotationviews
    static NSString *annotationIdentifier = @"icon_annotation";
    
    // Check in queue if there is an annotation view we already can use, else create a new one
    AWIconAnnotationView *annotationView = (AWIconAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!annotationView) {
        annotationView = [[AWIconAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x,
                              aV.frame.origin.y - self.view.frame.size.height,
                              aV.frame.size.width,
                              aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5
                              delay:0.04*[views indexOfObject:aV]
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             aV.frame = endFrame;
                             
                             // Animate squash
                         }completion:^(BOOL finished){
                             if (finished) {
                                 [UIView animateWithDuration:0.05 animations:^{
                                     aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                                     
                                 }completion:^(BOOL finished){
                                     if (finished) {
                                         [UIView animateWithDuration:0.1 animations:^{
                                             aV.transform = CGAffineTransformIdentity;
                                         }];
                                     }
                                 }];
                             }
                         }];
    }
}


@end
