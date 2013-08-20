//
//  AppDelegate.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "BackEndWrapper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MKMapViewDelegate, MKAnnotation,  MKOverlay, BackEndWrapperDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BackEndWrapper *wrapper;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView *routeLineView;


- (void)plotVehicles;

@end
