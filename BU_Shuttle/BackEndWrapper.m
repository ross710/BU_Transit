//
//  NetworkClient.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/2/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//


//  Plist loading/saving code mostly taken from http://ipgames.wordpress.com/tutorials/writeread-data-to-plist-file/

#import "BackEndWrapper.h"
#import "AppDelegate.h"
#define URL_STOPS [NSURL URLWithString:@"http://api.transloc.com/1.2/stops.json?agencies=bu"]
#define URL_VEHICLES [NSURL URLWithString:@"http://api.transloc.com/1.2/vehicles.json?agencies=bu"]
#define URL_ARRIVAL_ESTIMATES [NSURL URLWithString:@"http://api.transloc.com/1.2/arrival-estimates.json?agencies=bu"]
#define URL_ROUTES [NSURL URLWithString:@"http://api.transloc.com/1.2/routes.json?agencies=bu"]


@interface BackEndWrapper()
@property (nonatomic, retain) NSString *path;
@property (nonatomic) NSMutableData *dataObject;
@property (nonatomic) NSKeyedArchiver *archiver;
@property (nonatomic) NSKeyedUnarchiver *unarchiver;
@property (nonatomic) BOOL cool;
@end


@implementation BackEndWrapper
@synthesize path, dataObject, archiver, unarchiver;
@synthesize stops;
@synthesize delegate;
@synthesize cool;


//-(NSMutableDictionary *) loadArrivalEstimates {
//    NSString *json = [self getJsonStringArrivalEstimates];
//    return [self loadArrivalEstimatesIntoObjects:json];
//}


-(void) queueRoutes {
    //    dispatch_async(dispatch_get_global_queue(0, 0),
    //                   ^ {
    
    NSURLRequest* request = [NSURLRequest requestWithURL:URL_ROUTES cachePolicy:0 timeoutInterval:5];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         
         if ([data length] >0 && error == nil)
         {
             
             // DO YOUR WORK HERE
             NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             [self performSelectorOnMainThread:@selector(checkIfNightTime:) withObject:json waitUntilDone:YES];
             //             [self loadArrivalEstimatesIntoObjects:json];
             
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error = %@", error);
         }
         
     }];
    //    NSString *json = [self getJsonStringArrivalEstimates];
    //    [self loadArrivalEstimatesIntoObjects:json];
    //                   });
    
}

-(void) queueArrivalEstimates {
//    dispatch_async(dispatch_get_global_queue(0, 0),
//                   ^ {
    
    NSURLRequest* request = [NSURLRequest requestWithURL:URL_ARRIVAL_ESTIMATES cachePolicy:0 timeoutInterval:5];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         
         if ([data length] >0 && error == nil)
         {
             
             // DO YOUR WORK HERE
             NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             [self performSelectorOnMainThread:@selector(loadArrivalEstimatesIntoObjects:) withObject:json waitUntilDone:YES];
//             [self loadArrivalEstimatesIntoObjects:json];
             
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error = %@", error);
         }
         
     }];
//    NSString *json = [self getJsonStringArrivalEstimates];
//    [self loadArrivalEstimatesIntoObjects:json];
//                   });
    
}

-(void) queueVehicles {
//    dispatch_async(dispatch_get_global_queue(0, 0),
//                   ^ {
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:URL_VEHICLES cachePolicy:0 timeoutInterval:5];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         
         if ([data length] >0 && error == nil)
         {
             
             // DO YOUR WORK HERE
             NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             [self performSelectorOnMainThread:@selector(loadVehiclesIntoObjects:) withObject:json waitUntilDone:YES];

//             [self loadVehiclesIntoObjects:json];
             
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error = %@", error);
         }
         
     }];
//    NSString *json = [self getJsonStringVehicles];
//                   });
}


-(id) init {
    if (self = [super init]) {
        [self getPath];
        
        [self loadStops];
        
        [self queueRoutes];
        
        cool = NO;
        [NSTimer timerWithTimeInterval:3600 target:self selector:@selector(queueRoutes) userInfo:nil repeats:YES];
        //        [self loadArrivalEstimates];
    }
    return self;
}

//Just get path of stops.plist file
-(void) getPath {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"Stops.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Stops" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
}

//-(NSMutableDictionary *) getVehicles {
//    return [self loadVehiclesIntoObjects:[self getJsonStringVehicles]];
//}

-(void) loadStops {
    [self loadStopsFromDisk];
    //if did not load from plist
    if (!stops || [[stops allKeys] count] == 0) {
        //load from json
        NSString * stopsJSON = [self getJsonStringStops];
        [self loadStopsFromJSON:stopsJSON];
        
        NSLog(@"Stops loaded from JSON");
        
    } else {
        NSLog(@"Stops loaded from plist");
    }
    
//    [self queueRoutes];


    
    //        [self queueRoutes];

    
//    [self removeUnusedStops:YES];
}

//-(void) swapTime {
//    
//    if (cool) {
//        NSLog(@"COOL");
//        [self removeUnusedStops:NO];
//        cool = NO;
//        
//    } else {
//        NSLog(@"UNCOOL");
//
//        [self removeUnusedStops:YES];
//        cool = YES;
//    }
//    
//    [self.delegate updateStops];
//}

-(void) saveStops {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    dataObject = [[NSMutableData alloc] init];
    archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataObject];
    [archiver encodeObject:stops forKey:@"stops"];
    [archiver finishEncoding];
    
    [data setObject:dataObject forKey:@"stops"];
    [data writeToFile: path atomically:YES];
    
}

-(void) loadStopsFromDisk {
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:(NSData *) [savedData objectForKey:@"stops"]];
    stops = [unarchiver decodeObjectForKey:@"stops"];
}

-(void) loadStopsFromJSON: (NSString *) jsonString {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *stopsDict = [parser objectWithString:jsonString];
    
    stops = nil;
    stops = [[NSMutableDictionary alloc] init];
    NSArray *allTheStops = [stopsDict objectForKey:@"data"];
    for (id object in allTheStops) {
        NSDictionary *stopDict = (NSDictionary *) object;
//        NSLog(@"STROP DICT %@", stopDict);
        Stop *stop = [[Stop alloc]init];
        stop.name = [stopDict objectForKey:@"name"];
        
        NSDictionary *loc = [stopDict objectForKey:@"location"];
        stop.location = [[Location alloc] init:[loc objectForKey:@"lat"] :[loc objectForKey:@"lng"]];
        stop.stop_id = [NSNumber numberWithInt:[[stopDict objectForKey:@"stop_id"] integerValue]];
//        NSLog(@"ROUTES %@", [stopDict objectForKey:@"routes"]);
        stop.routes = [NSArray arrayWithArray:[stopDict objectForKey:@"routes"]];
        NSInteger stop_id = [stop.stop_id integerValue];
        
//        NSLog(@"STOP ID %d", stop_id);
        switch (stop_id) {
            case 4068466: //ST. Mary's
                stop.isInboundToStuVii = NO;
                break;
            case 4068470: //Blanford
                stop.isInboundToStuVii = NO;
                break;
            case 4068478: //Huntington EastBound
                stop.isInboundToStuVii = NO;
                break;
            case 4068482: //710 Albany
                stop.isInboundToStuVii = [[NSNumber alloc] initWithBool:YES];
                break;
            case 4068502: //Myles Standish
                stop.isInboundToStuVii = [[NSNumber alloc] initWithBool:YES];
                break;
            case 4068514: //Marsh Plaza
                stop.isInboundToStuVii = [[NSNumber alloc] initWithBool:YES];
                break;
            case 4108734: //518 Park Dr (South Campus)
                stop.isInboundToStuVii = NO;
                break;
            case 4108738: //Granby St
                stop.isInboundToStuVii = NO;
                break;
            case 4108742: //GSU
                stop.isInboundToStuVii = [[NSNumber alloc] initWithBool:YES];
                break;
            case 4110206: //Kenmore
                stop.isInboundToStuVii = NO;
                break;
            case 4110214: //CFA
                stop.isInboundToStuVii = [[NSNumber alloc] initWithBool:YES];
                break;
            case 4114006: //Agganis Way
                stop.isInboundToStuVii = [[NSNumber alloc] initWithBool:YES];
                break;
            case 4114010: //Danielsen Hall
                stop.isInboundToStuVii = [[NSNumber alloc] initWithBool:YES];
                break;
            case 4114014: //Silber Way
                stop.isInboundToStuVii = [[NSNumber alloc] initWithBool:YES];
                break;
            case 4117694: //815 Albany
                stop.isInboundToStuVii = [[NSNumber alloc] initWithBool:NO];
                break;
            case 4117698: //Amory St
                stop.isInboundToStuVii = NO;
                break;
            case 4117702: //Huntington Westbound
                stop.isInboundToStuVii = [[NSNumber alloc] initWithBool:YES];
                break;
            case 4117706: //StuVii (10 Buick St)
                stop.isInboundToStuVii = NO;
                break;
            case 4117710: //StuVii2
                stop.isInboundToStuVii = NO;
                break;
            default:
                break;
        }
        
        [stops setObject:stop forKey:stop.stop_id];
    }
    [self saveStops];
}

-(void) checkIfNightTime: (NSString*) json {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *full = [parser objectWithString:json];
    
    NSDictionary *data = [full objectForKey:@"data"];    
    NSArray *oneThirtyTwo = [data objectForKey:@"132"];
    
    for (id object in oneThirtyTwo) {
        NSDictionary *dict = (NSDictionary *) object;
        NSString *route_id = [dict objectForKey:@"route_id"];
        NSNumber *is_active = [dict objectForKey:@"is_active"];
        
        if ([route_id isEqualToString:@"4000946"]) {
            if ([is_active isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [self removeUnusedStops:YES];

                if ([self.delegate isKindOfClass:[AppDelegate class]]) {
                    [self.delegate switchToNight];
                } else {
                    [self.delegate updateStops];
                }
            } else {

                [self removeUnusedStops:NO];
                if ([self.delegate isKindOfClass:[AppDelegate class]]) {
                    [self.delegate switchToDay];
                } else {
                    [self.delegate updateStops];
                }
            }
        }
        
    }

}

-(void) removeUnusedStops :(BOOL) isNightTime {
    [self loadStopsFromDisk];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:stops];
    if (isNightTime) {
        for (id key in stops) {

            Stop *stop = [stops objectForKey:key];
            NSArray *routes = stop.routes;
            BOOL isPartOfRoute = NO;
//            for (NSNumber *route in routes) {
//                if ([route isEqualToNumber:[NSNumber numberWithInt:4000946]]) {
//                    isPartOfRoute = YES;
//                }
//            }
            for (NSString *route in routes) {
                if ([route isEqualToString:@"4000946"]) {
                    isPartOfRoute = YES;
                }
            }
            if (!isPartOfRoute) {
                [temp removeObjectForKey:stop.stop_id];
            }
        }

    } else {
        for (id key in stops) {
            Stop *stop = [stops objectForKey:key];
            NSArray *routes = stop.routes;
            BOOL isPartOfRoute = NO;
            for (NSString *route in routes) {
                if ([route isEqualToString:@"4002858"]) {
                    isPartOfRoute = YES;
                }
            }
            if (!isPartOfRoute) {
                [temp removeObjectForKey:stop.stop_id];
            }
        }

//        [temp removeObjectForKey:[NSNumber numberWithInt:4108734]]; //South Campus
//        [temp removeObjectForKey:[NSNumber numberWithInt:4108738]]; //Granby St
//        [temp removeObjectForKey:[NSNumber numberWithInt:4108742]]; //GSU
//        [temp removeObjectForKey:[NSNumber numberWithInt:4114006]]; //Agganis Way
//        [temp removeObjectForKey:[NSNumber numberWithInt:4117706]]; //Stuvi (10 Buick St)
        
    }

    stops = [NSMutableDictionary dictionaryWithDictionary:temp];
    
}

-(NSString *) getJsonStringStops {
    NSError* error = nil;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:URL_STOPS cachePolicy:0 timeoutInterval:5];
    NSURLResponse* response=nil;
    NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
//    return [NSString stringWithContentsOfURL:URL_STOPS encoding:NSASCIIStringEncoding error:&error];
}

-(NSString *) getJsonStringVehicles {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    
    NSError* error = nil;
//    return [NSString stringWithContentsOfURL:URL_VEHICLES encoding:NSASCIIStringEncoding error:&error];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:URL_VEHICLES cachePolicy:0 timeoutInterval:5];
    NSURLResponse* response=nil;
    NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"VEHICLES REFRESHING");
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSString *) getJsonStringArrivalEstimates {
    NSError* error = nil;
//    return [NSString stringWithContentsOfURL:URL_ARRIVAL_ESTIMATES encoding:NSASCIIStringEncoding error:&error];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:URL_ARRIVAL_ESTIMATES cachePolicy:0 timeoutInterval:5];
    NSURLResponse* response=nil;
    NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"ARRIVAL ESTIMATES REFRESHING");

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}




-(void) loadArrivalEstimatesIntoObjects: (NSString *) jsonString {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *bigDict = [parser objectWithString:jsonString];

    NSMutableDictionary *arrival_estimates = nil;
    arrival_estimates = [[NSMutableDictionary alloc] init];
//    NSLog(@"ARRIVAL EST: %@", jsonString);
    NSArray *allTheArrivalEstimates = [bigDict objectForKey:@"data"];
    
//   NSString *str = @"{ \"agency_id\" : 132, \"arrivals\" : [{ \"arrival_at\" : \"2013-08-16T22:33:09-04:00\", \"route_id\" : \"4002858\", \"type\" : \"vehicle-based\", \"vehicle_id\" : \"4007496\"},{ \"arrival_at\" : \"2013-08-16T22:58:29-04:00\", \"route_id\" : \"4002858\", \"type\" : \"vehicle-based\", \"vehicle_id\" : \"4007504\"}], \"stop_id\" : \"4117698\"}";
//
//    NSDictionary *dict = [parser objectWithString:str];
//
//    NSArray *allTheArrivalEstimates = [NSArray arrayWithObject:dict];
    for (id object in allTheArrivalEstimates) {
        NSDictionary *dict = (NSDictionary *) object;
//        NSLog(@"ARRIVAL ESTIMATES %@", dict);

        ArrivalEstimate *est = [[ArrivalEstimate alloc]init];
        est.stop_id = [NSNumber numberWithInteger:[[dict objectForKey:@"stop_id"] integerValue]];

        NSArray *arrivals = [dict objectForKey:@"arrivals"];
        
        if ([arrivals count] > 0) {
            NSDictionary *arrivalDict = [arrivals objectAtIndex:0];
            est.vehicle_id = [NSNumber numberWithInteger:[[arrivalDict objectForKey:@"vehicle_id"] integerValue]];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            
//            NSLog(@"DATE %@", [arrivalDict objectForKey:@"arrival_at"]);
            est.arrival_at = [dateFormat dateFromString:[arrivalDict objectForKey:@"arrival_at"]];
//            NSLog(@"ARRIVAL %@", est.arrival_at);
        }
        
        [arrival_estimates setObject:est forKey:est.stop_id];

    }
    
    [self.delegate recieveArrivalEstimates:arrival_estimates];
//    return arrival_estimates;
}

-(void) loadVehiclesIntoObjects: (NSString *) jsonString {
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *full = [parser objectWithString:jsonString];
    
    NSDictionary *allTheVehicles = [full objectForKey:@"data"];
    //    NSLog(@"ALL THE DATA %@", allTheVehicles);
    
    NSArray *oneThirtyTwo = [allTheVehicles objectForKey:@"132"];
    
    NSMutableDictionary *vehicles = [[NSMutableDictionary alloc] init];
    for (id object in oneThirtyTwo) {
        NSDictionary *vehicleDict = (NSDictionary *) object;
        //if ([[vehicleDict objectForKey:@"tracking_status"] isEqualToString:@"up"]) {
        
        //check if already a vehicle
        BOOL found = false;
        if (vehicles == nil
            ) {
            for (id object in vehicles) {
                Vehicle *tempVehicle = (Vehicle *) object;
                //if ids match, update
                
                if ([tempVehicle.vehicle_id isEqualToNumber:[vehicleDict objectForKey:@"vehicle_id"]]) {
                    found = true;
                    if ([vehicleDict objectForKey:@"heading"] != [NSNull null]) {
                        tempVehicle.heading = [NSNumber numberWithInteger:[[vehicleDict objectForKey:@"heading"] integerValue]];
                    }
                    NSDictionary *loc = [vehicleDict objectForKey:@"location"];
                    tempVehicle.location = [[Location alloc] init:[loc objectForKey:@"lat"] :[loc objectForKey:@"lng"]];
                    tempVehicle.tracking_status = [vehicleDict objectForKey:@"tracking_status"];
                    
                    tempVehicle.arrival_estimates = [vehicleDict objectForKey:@"arrival_estimates"];

                }
            }
        }
        if (found == false) { //if not found, add
            Vehicle *vehicle = [[Vehicle alloc]init];
            if ([vehicleDict objectForKey:@"heading"] != [NSNull null]) {
                vehicle.heading = [NSNumber numberWithInteger:[[vehicleDict objectForKey:@"heading"] integerValue]];
            }
            
            NSDictionary *loc = [vehicleDict objectForKey:@"location"];
            vehicle.location = [[Location alloc] init:[loc objectForKey:@"lat"] :[loc objectForKey:@"lng"]];
            
            vehicle.tracking_status = [vehicleDict objectForKey:@"tracking_status"];
            vehicle.arrival_estimates = [vehicleDict objectForKey:@"arrival_estimates"];

            vehicle.vehicle_id = [NSNumber numberWithInteger:[[vehicleDict objectForKey:@"vehicle_id"] integerValue]];
            
            vehicle.call_name = [NSNumber numberWithInteger:[[vehicleDict objectForKey:@"call_name"] integerValue]];

            switch ([vehicle.vehicle_id integerValue]) {
                case 4007492:
                {
                    vehicle.type = @"Small bus";
                    break;
                }
                case 4007496:
                {
                    vehicle.type = @"Small bus";
                    break;
                }
                case 4007500:
                {
                    vehicle.type = @"Small bus";
                    break;
                }
                case 4007504:
                {
                    vehicle.type = @"Small bus";
                    break;
                }
                case 4007508:
                {
                    vehicle.type = @"Small bus";
                    break;
                }
                case 4007512:
                {
                    vehicle.type = @"Big bus";
                    break;
                }
                case 4008320:
                {
                    vehicle.type = @"Big bus";
                    break;
                }
                case 4009127:
                {
                    vehicle.type = @"Big bus";
                    break;
                }
                default:
                {
                    vehicle.type = @"Unknown size of bus";
                    break;
                }
            }
//            [vehicles setObject:vehicle forKey:[vehicle.vehicle_id stringValue]];
            [vehicles setObject:vehicle forKey:vehicle.vehicle_id];

        }
    }
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self.delegate recieveVehicles:vehicles];
//    return vehicles;
}

//-(NSMutableDictionary *) loadVehiclesIntoObjects: (NSString *) jsonString {
//    
//    SBJsonParser *parser = [[SBJsonParser alloc] init];
//    NSDictionary *full = [parser objectWithString:jsonString];
//    
//    NSDictionary *allTheVehicles = [full objectForKey:@"data"];
//    //    NSLog(@"ALL THE DATA %@", allTheVehicles);
//    
//    NSArray *oneThirtyTwo = [allTheVehicles objectForKey:@"132"];
//    
//    //    NSMutableDictionary *vehicles = [[NSMutableDictionary alloc] init];
//    for (id object in oneThirtyTwo) {
//        NSDictionary *vehicleDict = (NSDictionary *) object;
//        //if ([[vehicleDict objectForKey:@"tracking_status"] isEqualToString:@"up"]) {
//        
//        
//        //check if already a vehicle
//        BOOL found = false;
//        if (vehicles != nil) {
//            //            for (id key in vehicles) {
//            Vehicle *tempVehicle = [vehicles objectForKey:[NSNumber numberWithInt:[[vehicleDict objectForKey:@"vehicle_id"] integerValue]]];
//            //if ids match, update
//            
//            
//            if (tempVehicle) {
//                NSLog(@"temp vehicle :%@", tempVehicle.vehicle_id);
//                
//                found = true;
//                if ([vehicleDict objectForKey:@"heading"] != [NSNull null]) {
//                    tempVehicle.heading = [NSNumber numberWithInteger:[[vehicleDict objectForKey:@"heading"] integerValue]];
//                }
//                NSDictionary *loc = [vehicleDict objectForKey:@"location"];
//                tempVehicle.location = [[Location alloc] init:[loc objectForKey:@"lat"] :[loc objectForKey:@"lng"]];
//                tempVehicle.tracking_status = [vehicleDict objectForKey:@"tracking_status"];
//                
//                tempVehicle.arrival_estimates = [vehicleDict objectForKey:@"arrival_estimates"];
//                
//            }
//            //            }
//        }
//        if (found == false) { //if not found, add
//            Vehicle *vehicle = [[Vehicle alloc]init];
//            if ([vehicleDict objectForKey:@"heading"] != [NSNull null]) {
//                vehicle.heading = [NSNumber numberWithInteger:[[vehicleDict objectForKey:@"heading"] integerValue]];
//            }
//            
//            NSDictionary *loc = [vehicleDict objectForKey:@"location"];
//            vehicle.location = [[Location alloc] init:[loc objectForKey:@"lat"] :[loc objectForKey:@"lng"]];
//            
//            vehicle.tracking_status = [vehicleDict objectForKey:@"tracking_status"];
//            vehicle.arrival_estimates = [vehicleDict objectForKey:@"arrival_estimates"];
//            
//            vehicle.vehicle_id = [NSNumber numberWithInteger:[[vehicleDict objectForKey:@"vehicle_id"] integerValue]];
//            
//            vehicle.call_name = [NSNumber numberWithInteger:[[vehicleDict objectForKey:@"call_name"] integerValue]];
//            
//            switch ([vehicle.vehicle_id integerValue]) {
//                case 4007492:
//                {
//                    vehicle.type = @"Small bus";
//                    break;
//                }
//                case 4007496:
//                {
//                    vehicle.type = @"Small bus";
//                    break;
//                }
//                case 4007500:
//                {
//                    vehicle.type = @"Small bus";
//                    break;
//                }
//                case 4007504:
//                {
//                    vehicle.type = @"Small bus";
//                    break;
//                }
//                case 4007508:
//                {
//                    vehicle.type = @"Small bus";
//                    break;
//                }
//                case 4007512:
//                {
//                    vehicle.type = @"Big bus";
//                    break;
//                }
//                default:
//                {
//                    vehicle.type = @"Unknown size of bus";
//                    break;
//                }
//            }
//            //            [vehicles setObject:vehicle forKey:[vehicle.vehicle_id stringValue]];
//            [vehicles setObject:vehicle forKey:vehicle.vehicle_id];
//            
//        }
//    }
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    
//    return vehicles;
//}


@end
