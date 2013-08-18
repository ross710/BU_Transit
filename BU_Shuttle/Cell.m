//
//  Cell.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/17/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "Cell.h"
@interface Cell ()


@end
@implementation Cell
@synthesize stopName,timeAway, inOrOutBound;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        stopName = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 280, 36)];
        stopName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
        
        UILabel *nextBusLabel = [[UILabel alloc] initWithFrame:CGRectMake(212, 48, 91, 21)];
        nextBusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
        nextBusLabel.text = @"next bus is:";
        
        UILabel *minutesAwayLabel = [[UILabel alloc] initWithFrame:CGRectMake(203, 112, 108, 21)];
        minutesAwayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
        minutesAwayLabel.text = @"minutes away";
        
        
        timeAway = [[UILabel alloc] initWithFrame:CGRectMake(215, 76, 85, 31)];
        timeAway.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
        timeAway.textAlignment = NSTextAlignmentCenter;
        
        
        inOrOutBound = [[UILabel alloc] initWithFrame:CGRectMake(32, 48, 160, 21)];
        inOrOutBound.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
        inOrOutBound.textAlignment = NSTextAlignmentLeft;
//        inOrOutBound.text = @"0.1";
        
        [self addSubview:stopName];
        [self addSubview:timeAway];
        [self addSubview:inOrOutBound];
        [self addSubview:nextBusLabel];
        [self addSubview:minutesAwayLabel];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
