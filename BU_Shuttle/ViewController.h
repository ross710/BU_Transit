//
//  ViewController.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>


#import "Vehicle_pin.h"
#import "AWIconAnnotationView.h"



@interface ViewController : UIViewController <MKMapViewDelegate, MKAnnotation, MKOverlay>{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
//    IBOutlet CLLocationManager *locationManager;
    CLLocation *myLocation;

    
    // the data representing the route points.
	MKPolyline* _routeLine;
	
    
	// the view we create for the line on the map
	MKPolylineView* _routeLineView;
	
	// the rect that bounds the loaded points
	MKMapRect _routeRect;
    
}

@property (nonatomic, retain) NSMutableArray *stops;
@property (nonatomic, retain) NSMutableDictionary *vehicles;
@property (weak, nonatomic) MKMapView *mapView;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;

@end
