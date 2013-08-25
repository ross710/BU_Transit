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

#import "AppDelegate.h"
#import "Vehicle_pin.h"
#import "BusAnnotationView.h"

@protocol MapViewDelegate <NSObject>

@required
-(void) gotoListView;

@end
@interface MapViewController : UIViewController<StreetViewSegueDelegate>

@property (nonatomic) BOOL shouldResetView;
@property (nonatomic, weak) id<MapViewDelegate> delegate;
@end
