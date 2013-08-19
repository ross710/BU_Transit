//
//  NetworkClient.h
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/2/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "Stop.h"
#import "Vehicle.h"
#import "ArrivalEstimate.h"

@interface BackEndWrapper : NSObject
@property (nonatomic, strong) NSMutableDictionary *stops;
//@property (nonatomic) NSMutableDictionary *vehicles;
@property (nonatomic) NSMutableDictionary *arrival_estimates;





-(NSMutableDictionary *) loadArrivalEstimates;
-(id) init;
-(void) getPath;
-(void) saveStops;
-(void) loadStops;
-(void) loadStopsFromJSON: (NSString *) jsonString;
-(NSMutableDictionary *) getVehicles;
-(NSString *) getJsonStringStops;
-(NSString *) getJsonStringVehicles;
-(NSString *) getJsonStringArrivalEstimates;
-(NSMutableDictionary *) loadArrivalEstimatesIntoObjects: (NSString *) jsonString;
-(NSMutableDictionary *) loadVehiclesIntoObjects: (NSString *) jsonString;
@end
