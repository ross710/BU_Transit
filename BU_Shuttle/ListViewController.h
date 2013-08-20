//
//  ListViewController.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/2/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "AppDelegate.h"
#import "Cell.h"



@interface ListViewController : UITableViewController <BackEndWrapperDelegate> {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation *myLocation;

}

@end
