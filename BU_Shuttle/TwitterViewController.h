//
//  TwitterViewController.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 2/20/14.
//  Copyright (c) 2014 Ross Tang Him. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TwitterViewDelegate <NSObject>

@required
-(void) gotoListViewfromTwitter;

@end

@interface TwitterViewController : UITableViewController
@property (weak, nonatomic) id<TwitterViewDelegate> delegate;
-(void) loadBUTwitter;
@end
