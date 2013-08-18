//
//  ListViewController.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/2/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "ListViewController.h"
#define URL_ARRIVAL_ESTIMATES [NSURL URLWithString:@"http://api.transloc.com/1.2/arrival-estimates.json?agencies=bu"]

@interface ListViewController ()
@property (nonatomic) NSArray *stopsArray;
@property (nonatomic) NSDictionary *stops;
@property (nonatomic) NSDictionary *arrival_estimates;
@property (nonatomic) NSArray *closestStops;
@end

@implementation ListViewController

@synthesize stops, closestStops, stopsArray, arrival_estimates;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    [self initLocation];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BackEndWrapper *wrapper = appDelegate.wrapper;
    
    stops = wrapper.stops;
    stopsArray = [wrapper.stops allValues];
    [self updateLocation];
    
    
    
    [self updateTable];
    
    [wrapper loadArrivalEstimates];
    arrival_estimates = wrapper.arrival_estimates;
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map >" style:UIBarButtonItemStylePlain target:self action:@selector(gotoMapView:)];
    self.navigationItem.rightBarButtonItem = mapButton;
    
//    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector: @selector(updateTable) userInfo: nil repeats: YES];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)gotoMapView:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"gotoMapView"
     object:self];
}

-(void) updateTable {
    
    [self.tableView reloadData];
}



-(void) initLocation {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    geocoder = [[CLGeocoder alloc] init];

}

- (NSString *)deviceLocation {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    return theLocation;
}

- (void)updateLocation {
//    NSLog(@"%@", [self deviceLocation]);

    myLocation = locationManager.location;
    
    
    
    [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            NSString *checkLength = [NSString stringWithFormat:@"%@ %@, %@, %@",
                                     placemark.subThoroughfare,
                                     placemark.thoroughfare,
                                     placemark.locality,
                                     placemark.administrativeArea];
            NSLog(@"%d", [checkLength length]);
            if ([checkLength length] <= 17) {
                [self setTitle:checkLength];
            } else if (placemark.subThoroughfare == NULL){
                [self setTitle:[NSString stringWithFormat:@"%@",
                                     placemark.thoroughfare]];
            } else {
                [self setTitle:[NSString stringWithFormat:@"%@ %@",
                                placemark.subThoroughfare,
                                placemark.thoroughfare]];
            }
            //            NSLog(@"%@", placemark.thoroughfare);
            //placemark.postalCode, placemark.locality,placemark.country
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    //calculate two closest stops
    closestStops = [self closestStops];

}


-(NSUInteger) closestStop: (NSMutableArray *) stops_ {
    NSDecimalNumber *smallestDistance = [[NSDecimalNumber alloc] initWithDouble:0];
    NSUInteger closest;
    
    NSUInteger count = 0;
    for (id object in stops_) {
        
        Stop *stop = (Stop *) object;
        NSDecimalNumber *distance = [self calculateDistance:stop.location];
        if ([smallestDistance isEqualToNumber:[[NSNumber alloc] initWithInt:0]]
            || [smallestDistance doubleValue] > [distance doubleValue]) {
            smallestDistance = distance;
            closest = count;
            //            NSLog(@"distance %@", distance);
        }
        count++;
    }
    return closest;
}


-(NSDecimalNumber *) calculateDistance: (Location *) loc{
    CLLocation *destination = [[CLLocation alloc] initWithLatitude:[loc.lat doubleValue] longitude:[loc.lng doubleValue]];
    
    //now convert to miles
    NSDecimalNumber *distance = [[NSDecimalNumber alloc] initWithDouble:[destination distanceFromLocation:myLocation] * 0.000621371192];
    
//    NSLog (@"Distance %@", distance);
    return distance;
}

////returns two closest
//-(NSArray *) closestStops {
//    Stop *stop1, *stop2;
//    
//    NSMutableArray *mut = [stopsArray mutableCopy];
//    NSUInteger firstIndex = [self closestStop:mut];
//    stop1 = [stopsArray objectAtIndex:firstIndex];
//    
//    [mut removeObjectAtIndex:firstIndex];
//    stop2 = [mut objectAtIndex:[self closestStop:mut]];
//    
//    return [NSArray arrayWithObjects: stop1, stop2, nil];
//}


//returns four closest
-(NSArray *) closestStops {
    Stop *stop1, *stop2, *stop3, *stop4;
    
    NSMutableArray *mut = [stopsArray mutableCopy];
    
    
    NSUInteger firstIndex, secondIndex, thirdIndex, fourthIndex;
    firstIndex = [self closestStop:mut];
    stop1 = [stopsArray objectAtIndex:firstIndex];
    
    
    [mut removeObjectAtIndex:firstIndex];
    secondIndex = [self closestStop:mut];
    stop2 = [mut objectAtIndex:secondIndex];
    
    
    [mut removeObjectAtIndex:secondIndex];
    thirdIndex = [self closestStop:mut];
    stop3 = [mut objectAtIndex:thirdIndex];
    
    [mut removeObjectAtIndex:thirdIndex];
    fourthIndex = [self closestStop:mut];
    stop4 = [mut objectAtIndex:fourthIndex];
    
    
    return [NSArray arrayWithObjects: stop1, stop2, stop3, stop4, nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [closestStops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell =  [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([closestStops count] > 0) {
            NSLog(@"HERE");
            Stop *stop = [closestStops objectAtIndex:indexPath.row];
            [cell.stopName setText:stop.name];
            
            ArrivalEstimate *est = [arrival_estimates objectForKey:stop.stop_id];
            if (est) {
                [cell.timeAway setText:[self minutesBetweenTwoDates:[NSDate date] :est.arrival_at]];
            } else {
                [cell.timeAway setText:@"--"];

            }
            
            if ([stop.isInboundToStuVii isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                [cell.inOrOutBound setText:@"(to West Campus)"];
                [cell.inOrOutBound setTextColor:[UIColor redColor]];
                [cell.stopName setTextColor:[UIColor redColor]];
            } else {
                [cell.inOrOutBound setText:@"(to Medical Campus)"];
            }
        }
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145.0;
}

-(NSString *) minutesBetweenTwoDates: (NSDate *) date1 :(NSDate *) date2 {
    unsigned int unitFlags = NSMinuteCalendarUnit;

    NSCalendar *currCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *conversionInfo = [currCalendar components:unitFlags fromDate:date1 toDate:date2  options:0];

//    if ([conversionInfo minute] < 1) {
//        return @"Arriving"
//    }
    return [NSString stringWithFormat:@"%d", [conversionInfo minute]];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
