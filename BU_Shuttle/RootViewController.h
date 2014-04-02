//
//  RootViewController.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/17/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "ListViewController.h"
#import "TwitterViewController.h"

@interface RootViewController : UIPageViewController <UIPageViewControllerDataSource, MapViewDelegate, ListViewDelegate, TwitterViewDelegate, UIPageViewControllerDelegate, UIGestureRecognizerDelegate>


@end
