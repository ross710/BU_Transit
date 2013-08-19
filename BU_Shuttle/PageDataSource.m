//
//  PageDataSource.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/17/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "PageDataSource.h"

@implementation PageDataSource



//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
//{
//    return [[UIViewController alloc] init];
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
//{
//    return [[UIViewController alloc] init];
//}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
//    if([viewController isKindOfClass:[ListViewController class]]){
//        ViewController *controller = (ViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapView"];
//        return controller;
//    }
//    else{
//        ListViewController *controller = (ListViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"listView"];
//        return controller;
//    }
    
    UIViewController *ctrl = ((UINavigationController*) viewController).visibleViewController;
    if([ctrl isKindOfClass:[MapViewController class]]){
        UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapNav"];
        return controller;
    }
    else{
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UIViewController *ctrl = ((UINavigationController*) viewController).visibleViewController;
    if([ctrl isKindOfClass:[ListViewController class]]){
        UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapNav"];
        return controller;
    }
    else{
        return nil;
    }
}



//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
//                                                             bundle: nil];
//    //    if([viewController isKindOfClass:[ListViewController class]]){
//    //        ViewController *controller = (ViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapView"];
//    //        return controller;
//    //    }
//    //    else{
//    //        ListViewController *controller = (ListViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"listView"];
//    //        return controller;
//    //    }
//    
//    
//    if([viewController isKindOfClass:[ViewController class]]){
//        ListViewController *controller = (ListViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapView"];
//        return controller;
//    }
//    else{
//        return nil;
//    }
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
//                                                             bundle: nil];
//    
//    if([viewController isKindOfClass:[ListViewController class]]){
//        ViewController *controller = (ViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapView"];
//        return controller;
//    }
//    else{
//        return nil;
//    }
//}

@end
