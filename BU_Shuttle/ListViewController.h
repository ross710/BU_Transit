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

//@protocol ListViewDelegate <NSObject>
//
//@required
//-(void) gotoMapView;
//
//@end


@interface ListViewController : UITableViewController <BackEndWrapperDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation *myLocation;

}
//@property (weak, nonatomic) id<ListViewDelegate> delegate;

@end
