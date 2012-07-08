//
//  UATViewController.m
//  UATeamClient
//
//  Created by Andriy Titov on 7/2/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import "UATViewController.h"

@interface UATViewController ()

@end

@implementation UATViewController

- (void) startAnimatingActivityView {
    [self.view bringSubviewToFront:activityView];
    [activityView show:YES];
}

- (void) stopAnimatingActivityView{
    [activityView hide:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    activityView = [[MBProgressHUD alloc] initWithView:self.view];
    activityView.labelText = @"Loading";
    [self.view addSubview:activityView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


@end
