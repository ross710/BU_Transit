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
@interface RootViewController : UIPageViewController <UIPageViewControllerDataSource, MapViewDelegate, ListViewDelegate, UIPageViewControllerDelegate>

@end
