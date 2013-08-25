//
//  HelpViewController.m
//  BU_Shuttle
//
//  Created by Ross Tang Him on 8/25/13.
//  Copyright (c) 2013 Ross Tang Him. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [[self navigationItem] setTitle:@"Help"];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissHelpView)];
    [[self navigationItem] setLeftBarButtonItem:button];
    
    
    
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help.png"]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        view.frame = CGRectMake(0, 100, 320, 320);
    } else {
        view.frame = CGRectMake(0, 0, 320, 320);
    }
    [self.view addSubview:view];
}

-(void) dismissHelpView {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
