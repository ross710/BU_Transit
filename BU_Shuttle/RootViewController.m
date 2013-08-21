//
//  RootViewController.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/17/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "RootViewController.h"
#import "PageDataSource.h"
#import "Stop_pin.h"

@interface RootViewController ()
@property (nonatomic) NSArray *vcArray;

@end

@implementation RootViewController
@synthesize vcArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization


    }
    return self;
}


-(void) gotoListView {
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
//                                                             bundle: nil];
//    UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"listNav"];
    [self setViewControllers:@[[vcArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:NULL];
}


-(void) gotoMapView: (NSNotification *) notification {
//    self.view = [self.dataSource pageViewController:self viewControllerAfterViewController:[self.viewControllers objectAtIndex:0]];

//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
//                                                             bundle: nil];
//    UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapNav"];
    UINavigationController *navC = [vcArray objectAtIndex:1];
    MapViewController *mapV = [navC.viewControllers objectAtIndex:0];
    mapV.shouldResetView = YES;
    [self setViewControllers:@[navC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    
    NSDictionary *dict = [notification userInfo];
    NSNumber *stop_id = [dict objectForKey:@"stop_id"];
    if (stop_id) {
        MKMapView *mapView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).mapView;
        for (Stop_pin<MKAnnotation> *currentAnnotation in mapView.annotations) {
            if ([currentAnnotation isKindOfClass:[Stop_pin class]] && [currentAnnotation.stop_id isEqualToNumber:stop_id]) {
                [mapView selectAnnotation:currentAnnotation animated:FALSE];
            }
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataSource = self;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    //    ListViewController *controller = (ListViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"listView"];
    UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"listNav"];
    UINavigationController *controller2 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapNav"];

    
    vcArray = [NSArray arrayWithObjects:controller, controller2, nil];
    
    [self setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished){}];
    
//    [mainStoryboard instantiateViewControllerWithIdentifier: @"mapNav"];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoListView)
                                                 name:@"gotoListView"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoMapView:)
                                                 name:@"gotoMapView"
                                               object:nil];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDataSource Methods

// Returns the view controller before the given view controller. (required)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    UIViewController *ctrl = ((UINavigationController*) viewController).visibleViewController;
    if([ctrl isKindOfClass:[MapViewController class]]){
        return [vcArray objectAtIndex:1];
    } else {
        return nil;
    }
}

// Returns the view controller after the given view controller. (required)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    UIViewController *ctrl = ((UINavigationController*) viewController).visibleViewController;
    if([ctrl isKindOfClass:[ListViewController class]]){
        return [vcArray objectAtIndex:1];
    } else {
        return nil;
    }
}



@end
