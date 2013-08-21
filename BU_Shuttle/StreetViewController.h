//
//  StreetViewController.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/20/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreetViewController : UIViewController
@property (nonatomic, readwrite) CLLocation *location;
@property (nonatomic, readwrite) NSString *name;
@end
