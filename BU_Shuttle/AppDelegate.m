//
//  AppDelegate.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 6/15/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "AppDelegate.h"
#import "Vehicle_pin.h"
#import "Stop_pin.h"
#import "BusAnnotationView.h"
#import "StopAnnotationView.h"
#import "STTwitter.h"


#define METERS_PER_MILE 1609.344
#define ZOOM_CONSTANT_IOS7 5150.0
#define ZOOM_CONSTANT 4500

@interface AppDelegate ()
@property (nonatomic, retain) NSMutableDictionary *vehicles;
@property (nonatomic) NSDate *lastDate;

@end
@implementation AppDelegate
@synthesize wrapper, mapView, routeLine, routeLineView;
@synthesize vehicles;

+(NSArray *) loadBUTwitter{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"MfKtvacL7cocr0fkpwIogg" consumerSecret:@"h8xR56SqeABsxM0LnuU36QVaTmFKjLUbUN6qeM6ytW0"];
    
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [twitter getUserTimelineWithScreenName:@"BUShuttle" successBlock:^(NSArray *statuses) {
            for (NSDictionary *status in statuses) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
                NSDate *date = [df dateFromString:[status objectForKey: @"created_at"]];
                if ([AppDelegate daysBetweenDate:date andDate:[NSDate date]] == 0){
                    [df setDateFormat:@"HH:mm"];
                    NSString *dateStr = [df stringFromDate:date];
                    NSString *text = [status objectForKey: @"text"];
                    
                    //array object at 0 = text
                    //array object at 1 = date
                    NSArray *statusAndDate = [NSArray arrayWithObjects:text, dateStr, nil];
                    [tweets addObject:statusAndDate];
                }
            }
        } errorBlock:^(NSError *error) {
            NSLog(@"-- error: %@", error);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"-- error %@", error);
    }];
    return [NSArray arrayWithArray:tweets];
}

//http://stackoverflow.com/questions/4739483/number-of-days-between-two-nsdates
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    
    return [difference day];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyBeiruW8tn-9bwuHNqp65nkF7LKc7dCfmE"];
    //init backendwrapper
    wrapper = [[BackEndWrapper alloc] init];
    wrapper.delegate = self;

    
    //init mapview and plot the stops
    mapView = [[MKMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    [self plotStops];

    //draw route lines
    [self loadRoute:NO];
    [mapView addOverlay:routeLine];
    
    //zoom to default location
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.34091;
    zoomLocation.longitude= -71.09682;
    MKCoordinateRegion viewRegion;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, ZOOM_CONSTANT_IOS7, ZOOM_CONSTANT_IOS7);
    } else {
        viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, ZOOM_CONSTANT, ZOOM_CONSTANT);
    }
    [mapView setRegion:viewRegion animated:NO];
    
    [self plotVehicles];
    return YES;
}

//Test for future code
//-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
////    NSLog(@"%d, %d", stopID, remindMinutes);
////    if (stopID != -1) {
////        //get arrival estimates
////        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.transloc.com/1.2/arrival-estimates.json?agencies=bu"] cachePolicy:0 timeoutInterval:5];
////        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
////        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
////        
////        NSUInteger minutesLeft = [self getTimeDifferenceFromJSON:dictionary];
////        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
////        localNotification.fireDate = [NSDate date];
////        
////        if (minutesLeft != -1) {
////            localNotification.alertBody = [NSString stringWithFormat:@"Bus arriving in: %d minutes", minutesLeft];
////        } else {
////            localNotification.alertBody = [NSString stringWithFormat:@"Sorry, bus alerts not available"];
////            
////        }
////        localNotification.soundName = UILocalNotificationDefaultSoundName;
////        NSLog(@"Minutes %d", minutesLeft);
//////        minutesLeft = 2;
////        if (remindMinutes >= minutesLeft) {
////            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
////            [self resetReminder];
//////            [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
////
////        }
////        
////        //fetch the latest content
////        completionHandler(UIBackgroundFetchResultNewData);
////    } else {
//////        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
////        completionHandler(UIBackgroundFetchResultFailed);
////    }
//    
//}




-(void) updateStops {
    [self refreshStops];
}

-(void) switchToDay {
    [self updateStops];
    [self loadRoute:NO];
}

-(void) switchToNight {
    [self updateStops];
    [self loadRoute:YES];
}

-(void) refreshStops {

    for (Stop_pin<MKAnnotation> *annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[Stop_pin class]]) {
            [mapView removeAnnotation:annotation];
        }
    }

    [self plotStops];
}


//Overlay code Taken from http://spitzkoff.com/craig/?p=136
-(void) loadRoute : (BOOL) isNightTime
{
    NSString* filePath;

    if (isNightTime) {
        filePath = [[NSBundle mainBundle] pathForResource:@"routeNight" ofType:@"csv"];
    } else {
        filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
    }
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // while we create the route points, we will also be calculating the bounding box of our route
    // so we can easily zoom in on it.
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;
    
    // create a c array of points.
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * pointStrings.count);
    
    for(int idx = 0; idx < pointStrings.count; idx++)
    {
        // break the string down even further to latitude and longitude fields.
        NSString* currentPointString = [pointStrings objectAtIndex:idx];

        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        CLLocationDegrees latitude = [[latLonArr objectAtIndex:0] doubleValue];
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
        
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        // if it is the first point, just use them, since we have nothing to compare to yet.
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        }
        else
        {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArr[idx] = point;
        
    }
    
    // create the polyline based on the array of points.
    self.routeLine = [MKPolyline polylineWithPoints:pointArr count:pointStrings.count];
    
    // clear the memory allocated earlier for the points
    free(pointArr);

}

-(void) plotStops {
    NSMutableDictionary *stops = [wrapper stops];
    
    for (id key in stops) {
        Stop *stop = [stops objectForKey:key];
        Stop_pin *annotation = [[Stop_pin alloc] initWithLong:[stop.location.lng doubleValue] :[stop.location.lat doubleValue] : [stop name] : [stop stop_id]];
        [mapView addAnnotation:annotation];
    }
}


-(void) receiveVehicles:(NSMutableDictionary *)object {
    vehicles = object;
    BOOL alreadyInit = NO;
    for (Vehicle_pin<MKAnnotation> *annotation in mapView.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]] && [annotation isKindOfClass:[Vehicle_pin class]]) {
            alreadyInit = YES;
            
            Vehicle *vehicle = [vehicles objectForKey:annotation.vehicle_id];
            
            if (vehicle) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake([vehicle.location.lat doubleValue],[vehicle.location.lng doubleValue]);
 
                [annotation setCoordinate:coord];
                [UIView commitAnimations];
                
                

                
                if ([vehicle.arrival_estimates count] > 0) {
                    NSDictionary *dict = [vehicle.arrival_estimates objectAtIndex:0];
                    BusAnnotationView *busView = (BusAnnotationView *)[mapView viewForAnnotation:annotation];
                    [busView tryToUpdateIcon:[self isInboundToStuvii:[dict objectForKey:@"stop_id"]]];
                }
            }
        }
    }
    
    if (!alreadyInit) {
        for (id key in vehicles) {
            Vehicle *vehicle = [vehicles objectForKey:key];
        
            Vehicle_pin *annotation = [[Vehicle_pin alloc] initWithLong:[vehicle.location.lng doubleValue] Lat:[vehicle.location.lat doubleValue] vehicle_id:vehicle.vehicle_id vehicle_num:vehicle.vehicle_num heading:vehicle.heading type:vehicle.type];
            if ([vehicle.arrival_estimates count] > 0) {
                NSDictionary *dict = [vehicle.arrival_estimates objectAtIndex:0];
                annotation.isInboundToStuvii = [NSNumber numberWithBool:[self isInboundToStuvii:[dict objectForKey:@"stop_id"]]];
            }
            [mapView addAnnotation:annotation];
        }
    }
}

- (void)plotVehicles {
    [wrapper queueVehicles];
}


-(BOOL) isInboundToStuvii : (NSNumber *) stopId{
    NSInteger stop_id = [stopId integerValue];
    switch (stop_id) {
        case 4068466: //ST. Mary's
            return NO;
            break;
        case 4068470: //Blanford
            return NO;
            break;
        case 4068478: //Huntington EastBound
            return NO;
            break;
        case 4068482: //710 Albany
            return YES;
            break;
        case 4068502: //Myles Standish
            return YES;
            break;
        case 4068514: //Marsh Plaza
            return YES;
            break;
        case 4108734: //518 Park Dr (South Campus)
            return NO;
            break;
        case 4108738: //Granby St
            return NO;
            break;
        case 4108742: //GSU
            return YES;
            break;
        case 4110206: //Kenmore
            return NO;
            break;
        case 4110214: //CFA
            return YES;
            break;
        case 4114006: //Agganis Way
            return YES;
            break;
        case 4114010: //Danielsen Hall
            return YES;
            break;
        case 4114014: //Silber Way
            return YES;
            break;
        case 4117694: //815 Albany
            return NO;
            break;
        case 4117698: //Amory St
            return NO;
            break;
        case 4117702: //Huntington Westbound
            return YES;
            break;
        case 4117706: //StuVii (10 Buick St)
            return NO;
            break;
        case 4117710: //StuVii2
            return NO;
            break;
        default:
            return NO;
            break;
    }
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay
{
    MKOverlayView *overlayView = nil;
    
    if(overlay == self.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.strokeColor = [UIColor blueColor];
            self.routeLineView.alpha = 0.8;
            self.routeLineView.lineWidth = 3;
        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (annotation == aMapView.userLocation) {
        return nil; // Let map view handle user location annotation
    }
    
    if ([annotation isKindOfClass:[Vehicle_pin class]]) {
        // Identifyer for reusing annotationviews
        static NSString *annotationIdentifier = @"icon_vehicle";
        // Check in queue if there is an annotation view we already can use, else create a new one
        BusAnnotationView *annotationView = (BusAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!annotationView) {
            annotationView = [[BusAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:annotationIdentifier];
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        return annotationView;
    } else if ([annotation isKindOfClass:[Stop_pin class]]) {
        // Identifyer for reusing annotationviews
        static NSString *annotationIdentifier = @"icon_stop";
        // Check in queue if there is an annotation view we already can use, else create a new one
        StopAnnotationView *annotationView = (StopAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!annotationView) {
            annotationView = [[StopAnnotationView alloc] initWithAnnotation:annotation
                                                            reuseIdentifier:annotationIdentifier];
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        }
        return annotationView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    view.layer.zPosition = 2049;
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([[view annotation] isKindOfClass:[MKUserLocation class]])
    {
        view.layer.zPosition = 2049;
    } else if ([[view annotation] isKindOfClass:[Vehicle_pin class]])
    {
        view.layer.zPosition = 2047;
    }
    else
    {
        view.layer.zPosition = 2048;
    }

}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"map_active" object:nil];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"map_inactive" object:nil];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        if ([[aV annotation] isKindOfClass:[MKUserLocation class]])
        {
            aV.layer.zPosition = 2049;
            continue;
        } else if ([[aV annotation] isKindOfClass:[Vehicle_pin class]])
        {
            aV.layer.zPosition = 2047;
        }
        else
        {
            aV.layer.zPosition = 2048;

        }
        
        
        // Check if current annotation is inside visible map rect
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x,
                              aV.frame.origin.y - self.mapView.frame.size.height,
                              aV.frame.size.width,
                              aV.frame.size.height);
        aV.frame = endFrame;
    }
}

//when you touch an annotation, open street view
-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    Stop_pin *pin = (Stop_pin*)[view annotation];
    [self.delegate showStreetView:pin];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
