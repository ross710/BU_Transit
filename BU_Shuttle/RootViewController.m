//
//  RootViewController.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/17/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "RootViewController.h"
#import "Stop_pin.h"

@interface RootViewController ()
@property (nonatomic) NSArray *vcArray;
@property (nonatomic) BOOL canTransition;

@end

@implementation RootViewController
@synthesize vcArray, canTransition;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization


    }
    return self;
}

//http://stackoverflow.com/questions/13633059/uipageviewcontroller-how-do-i-correctly-jump-to-a-specific-page-without-messing
-(void) gotoListView {
    __weak RootViewController* pvcw = self;
    [self setViewControllers:@[[vcArray objectAtIndex:1]]
                  direction:UIPageViewControllerNavigationDirectionReverse
                   animated:YES completion:^(BOOL finished) {
                       RootViewController* pvcs = pvcw;
                       if (!pvcs) return;
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [pvcs setViewControllers:@[[pvcs.vcArray objectAtIndex:1]]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:NO completion:nil];
                       });
                   }];

}

-(void) gotoTwitterView {
    __weak RootViewController* pvcw = self;
    [self setViewControllers:@[[vcArray objectAtIndex:0]]
                   direction:UIPageViewControllerNavigationDirectionReverse
                    animated:YES completion:^(BOOL finished) {
                        RootViewController* pvcs = pvcw;
                        if (!pvcs) return;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [pvcs setViewControllers:@[[pvcs.vcArray objectAtIndex:0]]
                                           direction:UIPageViewControllerNavigationDirectionReverse
                                            animated:NO completion:nil];
                        });
                    }];
}

-(void) gotoListViewfromTwitter {
    __weak RootViewController* pvcw = self;
    [self setViewControllers:@[[vcArray objectAtIndex:1]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES completion:^(BOOL finished) {
                        RootViewController* pvcs = pvcw;
                        if (!pvcs) return;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [pvcs setViewControllers:@[[pvcs.vcArray objectAtIndex:1]]
                                           direction:UIPageViewControllerNavigationDirectionForward
                                            animated:NO completion:nil];
                        });
                    }];
}



-(void) gotoMapView:(NSNumber *)vehicle_id {
        UINavigationController *navC = [vcArray objectAtIndex:2];
        MapViewController *mapV = [navC.viewControllers objectAtIndex:0];
        mapV.shouldResetView = YES;

    __weak UIPageViewController* pvcw = self;
    [self setViewControllers:@[navC]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES completion:^(BOOL finished) {
                        UIPageViewController* pvcs = pvcw;
                        if (!pvcs) return;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [pvcs setViewControllers:@[navC]
                                           direction:UIPageViewControllerNavigationDirectionForward
                                            animated:NO completion:nil];
                        });
                    }];
    
    //for highlighting annotation
        if (vehicle_id) {
            MKMapView *mapView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).mapView;
            for (Vehicle_pin<MKAnnotation> *annotation in mapView.annotations) {
                if ([annotation isKindOfClass:[Vehicle_pin class]] && [annotation.vehicle_id isEqualToNumber:vehicle_id]) {
                    [mapView selectAnnotation:annotation animated:FALSE];
                    continue;
                }
            }

        }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.dataSource = self;
    self.delegate = self;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"listNav"];
    ListViewController *listView = [mainStoryboard instantiateViewControllerWithIdentifier:@"listView"];
    listView.delegate = self;
    [controller setViewControllers:@[listView]];
    
    UINavigationController *controller2 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapNav"];
    MapViewController *mapView = [mainStoryboard instantiateViewControllerWithIdentifier:@"mapView"];
    mapView.delegate = self;
    [controller2 setViewControllers:@[mapView]];
    
    UINavigationController *controller3 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"twitterNav"];
    TwitterViewController *twitterView = [mainStoryboard instantiateViewControllerWithIdentifier:@"twitterView"];
    twitterView.delegate = self;
    [controller3 setViewControllers:@[twitterView]];
    
    vcArray = [NSArray arrayWithObjects:controller3, controller, controller2, nil];
    
    [self setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished){}];
    

    canTransition = YES;
    for (UIGestureRecognizer *gR in self.view.gestureRecognizers) {
        gR.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {


}

-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {

}


#pragma mark - UIPageViewControllerDataSource Methods

// Returns the view controller before the given view controller. (required)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger currentIndex = [vcArray indexOfObject:viewController];
    if(currentIndex == 0)
        return nil;
    
    return [vcArray objectAtIndex:currentIndex -1];

}



// Returns the view controller after the given view controller. (required)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [vcArray indexOfObject:viewController];
    if(currentIndex == vcArray.count - 1)
        return nil;
    
    return [vcArray objectAtIndex:currentIndex + 1];

}



@end
