//
//  Location.h
//  BU Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject <NSObject>
@property (nonatomic, copy) NSDecimalNumber *lat;
@property (nonatomic, copy) NSDecimalNumber *lng;
@property (nonatomic, copy) NSDecimalNumber *distance;

-(id) init;
-(id) init: (NSDecimalNumber*) lat_ : (NSDecimalNumber*) lng_;
@end
