//
//  ListViewController.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/2/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "ListViewController.h"
#import "HelpViewController.h"
#define URL_ARRIVAL_ESTIMATES [NSURL URLWithString:@"http://api.transloc.com/1.2/arrival-estimates.json?agencies=bu"]

@interface ListViewController ()
@property (nonatomic) NSArray *stopsArray;
@property (nonatomic) NSDictionary *stops;
@property (nonatomic) NSDictionary *arrival_estimates;
@property (nonatomic) NSArray *closestStops;
@property (nonatomic) NSTimer *locationTimer;
@property (nonatomic) NSTimer *arrivalEstimatesTimer;

@property (nonatomic) NSUInteger stopID;
@property (nonatomic) NSUInteger remindMinutes;

@property (atomic) BOOL delayWarning;

@property (nonatomic) BackEndWrapper *wrapper;
@end

@implementation ListViewController

@synthesize stops, closestStops, stopsArray, arrival_estimates;
@synthesize wrapper;
@synthesize locationTimer, arrivalEstimatesTimer;
@synthesize delayWarning;
@synthesize stopID, remindMinutes;

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
    delayWarning = NO;
    
    [super viewDidLoad];
    [self initLocation];
    wrapper = [[BackEndWrapper alloc] init];

    wrapper.delegate = self;
    
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(showHelpView)];
    [[self navigationItem] setLeftBarButtonItem:button];
    
    if (wrapper.stops &&[[wrapper.stops allKeys] count] > 0) {
        [self performSelector:@selector(continueInit) withObject:nil afterDelay:0];
    } else {

        [self performSelector:@selector(continueInit) withObject:nil afterDelay:0.5];

    }
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self performSelector:@selector(checkIfRunning) withObject:self afterDelay:3.0];

}

-(void) checkIfRunning {
//    arrival_estimates
    NSArray *keysArray = [arrival_estimates allValues];
    
    if ([keysArray count] <= 0 && delayWarning == NO) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry Mate" message:@"Buses don't appear to be running at this time, but you can check the map to confirm" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        
        
    }
//    for (id key in arrival_estimates) {
//        ArrivalEstimate *est = [arrival_estimates objectForKey:key];
//        NSLog(@"subdict %@", est.arrival_at);
////        if ([subDictionary objectForKey:@"type"] == @"title")
////            [titles addObject:[subDictionary objectForKey:@"title"]];
//        // etc.
//        isRunning = YES;
//    }
//    
//    if (!isRunning) {
//
//    }
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//    Cell *cell = (Cell*)[self.tableView cellForRowAtIndexPath:indexPath];
//    if ([[cell.timeAway text] isEqualToString:@"--"]) {
//
//    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) createBusNotification:stopID time:remindMinutes];
    }
//    //dismiss for an hour
//    if (buttonIndex == 1)
//    {
//        NSLog(@"Dismiss for a while");
//        delayWarning = YES;
//        NSUInteger time = 20;
//        [self performSelector:@selector(releaseDelay) withObject:self afterDelay:time];
//    }
}
-(void) releaseDelay {
    delayWarning = NO;
}
-(void) continueInit{
    

    if (wrapper.stops && [[wrapper.stops allKeys] count] > 0) {
        stops = wrapper.stops;
        stopsArray = [wrapper.stops allValues];
        //    [self updateLocation];
        
        
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map >" style:UIBarButtonItemStylePlain target:self action:@selector(gotoMapView:)];
        self.navigationItem.rightBarButtonItem = mapButton;
        
        

        
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
        
        [self updateLocation];
        [self updateArrivalEstimates];
        locationTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self selector: @selector(updateLocation) userInfo: nil repeats: YES];
        arrivalEstimatesTimer = [NSTimer scheduledTimerWithTimeInterval: 6.0 target: self selector: @selector(updateArrivalEstimates) userInfo: nil repeats: YES];
    } else {

        [self performSelector:@selector(continueInit) withObject:nil afterDelay:0.5];
    }
}

-(void) showHelpView {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    HelpViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HelpViewController"];
    UINavigationController *navView = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navView animated:YES completion:nil];
    
    
}

- (void)handleRefresh:(id)sender
{
    [self updateLocation];
    [self updateArrivalEstimates];
}
-(void) viewDidUnload {
    wrapper.delegate = nil;
}
-(void) viewDidAppear:(BOOL)animated {
//    dispatch_async(dispatch_get_global_queue(0, 0),
//                   ^ {
//                       [self updateLocation];
//                       [self updateArrivalEstimates];
////                       [self resumeTimer];
//                   });
//    [self updateLocation];
//    [self updateArrivalEstimates];
//    [self resumeTimer];

}

-(void) viewDidDisappear:(BOOL)animated {
//    [self pauseTimer];
}

-(void) pauseTimer {
//    [locationTimer invalidate];
//    locationTimer = nil;
//    [arrivalEstimatesTimer invalidate];
//    arrivalEstimatesTimer = nil;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self pauseTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self resumeTimer];
}
-(void) resumeTimer {
//    [self updateLocation];
//    [self updateArrivalEstimates];
//    locationTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self selector: @selector(updateLocation) userInfo: nil repeats: YES];
//    arrivalEstimatesTimer = [NSTimer scheduledTimerWithTimeInterval: 6.0 target: self selector: @selector(updateArrivalEstimates) userInfo: nil repeats: YES];
}
- (void)gotoMapView:(id)sender {
    [self.delegate gotoMapView: nil];
}


-(void) updateArrivalEstimates {
    [wrapper queueArrivalEstimates];
}

-(void) recieveArrivalEstimates : (NSMutableDictionary *) object{
    arrival_estimates = object;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}



-(void) initLocation {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];


    locationManager.delegate = self;
    geocoder = [[CLGeocoder alloc] init];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [locationManager stopUpdatingLocation];

    myLocation = [locations lastObject];
    [self saveLocationData];
}

- (NSString *)deviceLocation {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    return theLocation;
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    closestStops = [NSMutableArray arrayWithArray:stopsArray];
    
    [self.tableView reloadData];
}
-(void) saveLocationData {

    
    [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {

        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            NSString *checkLength = [NSString stringWithFormat:@"%@ %@, %@, %@",
                                     placemark.subThoroughfare,
                                     placemark.thoroughfare,
                                     placemark.locality,
                                     placemark.administrativeArea];

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

        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    //calculate two closest stops
    closestStops = [NSMutableArray arrayWithArray:[self closestStops]];
    
    [self.tableView reloadData];
}
- (void)updateLocation {
    [locationManager startUpdatingLocation];
}


-(NSUInteger) closestStop: (NSMutableArray *) stops_ {
    NSDecimalNumber *smallestDistance = [[NSDecimalNumber alloc] initWithDouble:0];
    NSUInteger closest = 0;
    
    NSUInteger count = 0;
    for (id object in stops_) {
        
        Stop *stop = (Stop *) object;
        NSDecimalNumber *distance = [self calculateDistance:stop.location];
        if ([smallestDistance isEqualToNumber:[[NSNumber alloc] initWithInt:0]]
            || [smallestDistance doubleValue] > [distance doubleValue]) {
            smallestDistance = distance;
            closest = count;
        }
        count++;
    }
    return closest;
}


-(NSDecimalNumber *) calculateDistance: (Location *) loc{
    CLLocation *destination = [[CLLocation alloc] initWithLatitude:[loc.lat doubleValue] longitude:[loc.lng doubleValue]];
    
    //now convert to miles
    NSDecimalNumber *distance = [[NSDecimalNumber alloc] initWithDouble:[destination distanceFromLocation:myLocation] * 0.000621371192];
    
    return distance;
}


-(void) updateStops {
    if (wrapper.stops && [[wrapper.stops allKeys] count] > 0) {
        stops = wrapper.stops;
        stopsArray = [wrapper.stops allValues];
        [self updateLocation];
    }
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
    
    
    NSInteger firstIndex, secondIndex, thirdIndex, fourthIndex;
//    firstIndex = 0;
//    secondIndex = 0;
//    thirdIndex = 0;
//    fourthIndex = 0;
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

    }
    if ([closestStops count] > 0) {
        Stop *stop = [closestStops objectAtIndex:indexPath.row];
        [cell.stopName setText:stop.name];
        
        ArrivalEstimate *est = [arrival_estimates objectForKey:stop.stop_id];
        if (est) {
            [cell.timeAway setText:[self minutesBetweenTwoDates:[NSDate date] :est.arrival_at]];
            if ([[self isBigBus:est.vehicle_id] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                [cell.busType setText:@"Big Bus"];
            } else if ([[self isBigBus:est.vehicle_id] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                [cell.busType setText:@"Small Bus"];
            } else {
                [cell.busType setText:@""];
            }
        } else {
            [cell.timeAway setText:@"--"];
            [cell.busType setText:@""];
        }
        if ([stop.isInboundToStuVii isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            [cell.inOrOutBound setText:@"(to West Campus)"];
            [cell.inOrOutBound setTextColor:[UIColor redColor]];
            [cell.stopName setTextColor:[UIColor redColor]];
        } else {
            [cell.inOrOutBound setText:@"(to East/Med Campus)"];
            [cell.inOrOutBound setTextColor:[UIColor blackColor]];
            [cell.stopName setTextColor:[UIColor blackColor]];
        }
    }
    return cell;
}

-(NSNumber *) isBigBus : (NSNumber *) vehicle_id {
    NSInteger vehId = [vehicle_id integerValue];
    switch (vehId) {
        case 4007492:
        {
            return [NSNumber numberWithBool:NO];
            break;
        }
        case 4007496:
        {
            return [NSNumber numberWithBool:NO];
            break;
        }
        case 4007500:
        {
            return [NSNumber numberWithBool:NO];
            break;
        }
        case 4007504:
        {
            return [NSNumber numberWithBool:NO];
            break;
        }
        case 4007508:
        {
            return [NSNumber numberWithBool:NO];
            break;
        }
        case 4007512:
        {
            return [NSNumber numberWithBool:YES];
            break;
        }
        case 4007516:
        {
            return [NSNumber numberWithBool:YES];
            break;
        }
        case 4008320:
        {
            return [NSNumber numberWithBool:YES];
            break;
        }
        case 4009127:
        {
            return [NSNumber numberWithBool:YES];
            break;
        }
        default:
        {
            return nil;
            break;
        }
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145.0;
}

-(NSString *) minutesBetweenTwoDates: (NSDate *) date1 :(NSDate *) date2 {
    unsigned int unitFlags = NSMinuteCalendarUnit;

    NSCalendar *currCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *conversionInfo = [currCalendar components:unitFlags fromDate:date1 toDate:date2  options:0];
    
    NSInteger numMin = [conversionInfo minute];
    if (numMin < -10) {
        return @"???";
    }
    return [NSString stringWithFormat:@"%d", [conversionInfo minute]];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Stop *stop = [closestStops objectAtIndex:indexPath.row];
//    NSUInteger minutes = 2;
//    stopID = [stop.stop_id integerValue];
//    remindMinutes = minutes;
//    NSString *msg = [NSString stringWithFormat:
//                     @"Should I tell you when a bus is %d minutes away from %@? Any previous reminders will be canceled.",
//                     minutes, [stop name]];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert when bus arrives?"
//                                                    message: msg
//                                                   delegate: nil
//                                          cancelButtonTitle:@"Cancel"
//                                          otherButtonTitles:@"Schedule",nil];
//    alert.delegate = self;
//    [alert show];

//    [self.delegate gotoMapView:stop.stop_id];
    
    

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
