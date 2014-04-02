//
//  TwitterViewController.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 2/20/14.
//  Copyright (c) 2014 Ross Tang Him. All rights reserved.
//

#import "TwitterViewController.h"
#import "AppDelegate.h"
#import "STTwitter.h"
#import "HelpViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface TwitterViewController ()
@property (nonatomic) NSArray *tweets;
@end

@implementation TwitterViewController
@synthesize tweets;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) loadBUTwitter{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"MfKtvacL7cocr0fkpwIogg" consumerSecret:@"h8xR56SqeABsxM0LnuU36QVaTmFKjLUbUN6qeM6ytW0"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [twitter getUserTimelineWithScreenName:@"BUShuttle" successBlock:^(NSArray *statuses) {
            NSMutableArray *tweetsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *status in statuses) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
                NSDate *date = [df dateFromString:[status objectForKey: @"created_at"]];
                if ([self isSameDay:date andDate:[NSDate date]]){
                    [df setDateFormat:@"HH:mm a"];
                    NSString *dateStr = [df stringFromDate:date];
                    NSString *text = [status objectForKey: @"text"];
                    
                    NSString *tweet = [NSString stringWithFormat:@"%@\n%@", dateStr,text];
                    //array object at 0 = text
                    //array object at 1 = date
                    //                    NSArray *statusAndDate = [NSArray arrayWithObjects:text, dateStr, nil];
                    //                    [tweetsArray addObject:statusAndDate];
                    [tweetsArray addObject:tweet];
                }
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.tweets = tweetsArray;
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }];
            
            
        } errorBlock:^(NSError *error) {
            NSLog(@"-- error: %@", error);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"-- error %@", error);
    }];
}


////http://stackoverflow.com/questions/4739483/number-of-days-between-two-nsdates
//- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
//{
//    NSDate *fromDate;
//    NSDate *toDate;
//
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//
//    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
//                 interval:NULL forDate:fromDateTime];
//    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
//                 interval:NULL forDate:toDateTime];
//
//    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
//                                               fromDate:fromDate toDate:toDate options:0];
//
//    return [difference day];
//}

-(BOOL) isLessThanHours: (NSInteger) hours date: (NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    if ([toDateTime timeIntervalSinceDate:fromDateTime] < 3600*hours)
    {
        return YES;
    }
    return NO;
}

-(BOOL) isSameDay: (NSDate *)fromDate andDate: (NSDate*) toDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy.MM.dd";
    
    NSString *d1 = [df stringFromDate:fromDate];
    NSString *d2 = [df stringFromDate:toDate];
    return [d1 isEqualToString:d2];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"List View >" style:UIBarButtonItemStylePlain target:self action:@selector(gotoListView)];
    self.navigationItem.rightBarButtonItem = listButton;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(showHelpView)];
    [[self navigationItem] setLeftBarButtonItem:button];
    
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(loadBUTwitter)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    //show refresh initially
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
    
    [self loadBUTwitter];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) showHelpView {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    HelpViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HelpViewController"];
    UINavigationController *navView = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navView animated:YES completion:nil];
    
    
}

-(void) gotoListView {
    [self.delegate gotoListViewfromTwitter];
}
-(void) viewWillAppear:(BOOL)animated {
    //    tweets = [AppDelegate loadBUTwitter];
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
    
    switch (section) {
        case 0:
            if ([tweets count] == 0) {
                return 1;
            } else {
                return [tweets count];
            }
            break;
//        case 1:
//            return 1;
//            break;
        default:
            break;
    }
    // Return the number of rows in the section.
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"@BUShuttle Tweets";
            break;
//        case 1:
//            return @"Settings";
//            break;
        default:
            break;
    }
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        NSString *text = [tweets objectAtIndex:[indexPath row]];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height, 44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    } else {
        return 64;
    }
}

//http://www.cimgf.com/2009/09/23/uitableviewcell-dynamic-height/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {



    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        UILabel *label;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [label setTag:1];
            
            
            [[cell contentView] addSubview:label];
            
        }
        NSString *text = [tweets objectAtIndex:[indexPath row]];
        if ([tweets count] == 0) {
//            text = @"No recent tweets from @BUShuttle";
        }
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        if (!label)
            label = (UILabel*)[cell viewWithTag:1];
        
        [label setText:text];
        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
        


        return cell;

    } else {
        static NSString *CellIdentifier2 = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            if (indexPath.row == 0 && indexPath.section != 0) {
                cell.textLabel.text = @"Disable Notifications";
            }
        }
        return cell;

    }
    
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
