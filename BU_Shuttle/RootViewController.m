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
    __weak UIPageViewController* pvcw = self;
    [self setViewControllers:@[[vcArray objectAtIndex:0]]
                  direction:UIPageViewControllerNavigationDirectionReverse
                   animated:YES completion:^(BOOL finished) {
                       UIPageViewController* pvcs = pvcw;
                       if (!pvcs) return;
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [pvcs setViewControllers:@[[vcArray objectAtIndex:0]]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:NO completion:nil];
                       });
                   }];
//        [self setViewControllers:@[[vcArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:NULL];
}





-(void) gotoMapView:(NSNumber *)stop_id {
        UINavigationController *navC = [vcArray objectAtIndex:1];
        MapViewController *mapV = [navC.viewControllers objectAtIndex:0];
        mapV.shouldResetView = YES;
//        [self setViewControllers:@[navC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
//    
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
//        if (stop_id) {
//            MKMapView *mapView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).mapView;
//            for (Stop_pin<MKAnnotation> *currentAnnotation in mapView.annotations) {
//                if ([currentAnnotation isKindOfClass:[Stop_pin class]] && [currentAnnotation.stop_id isEqualToNumber:stop_id]) {
//                    [mapView selectAnnotation:currentAnnotation animated:FALSE];
//                    continue;
//                }
//            }
//        }
    
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
    
    vcArray = [NSArray arrayWithObjects:controller, controller2, nil];
    
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
//    canTransition = NO;
//    [[[[[vcArray objectAtIndex:0] viewControllers] objectAtIndex:0] navigationItem] rightBarButtonItem].enabled = NO;
//
//    [[[[[vcArray objectAtIndex:1] viewControllers] objectAtIndex:0] navigationItem] leftBarButtonItem].enabled = NO;

}

-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
//    [[[[[vcArray objectAtIndex:0] viewControllers] objectAtIndex:0] navigationItem] rightBarButtonItem].enabled = YES;
//    
//    [[[[[vcArray objectAtIndex:1] viewControllers] objectAtIndex:0] navigationItem] leftBarButtonItem].enabled = YES;
//    if (completed) {
//        canTransition = YES;
//    }
}

//-(void) fixBlackScreen {
//    if (![[self.viewControllers objectAtIndex:0] isKindOfClass:[MapViewController class]] && ![[self.viewControllers objectAtIndex:0] isKindOfClass:[ListViewController class]]) {
//        [self gotoListView];
//    }
//}
#pragma mark - UIPageViewControllerDataSource Methods

// Returns the view controller before the given view controller. (required)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    UIViewController *ctrl = ((UINavigationController*) viewController).visibleViewController;
    if([ctrl isKindOfClass:[MapViewController class]]){
        return [vcArray objectAtIndex:1];
    }  else if (ctrl == nil) {
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
    } else if (ctrl == nil) {
        return [vcArray objectAtIndex:1];
    } else {
        return nil;
    }
}



@end
