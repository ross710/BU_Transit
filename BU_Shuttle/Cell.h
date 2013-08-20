//
//  Cell.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/17/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UITableViewCell
@property (nonatomic) UILabel *stopName;
@property (nonatomic) UILabel *timeAway;
@property (nonatomic) UILabel *inOrOutBound;
@property (nonatomic) UILabel *busType;

@end
