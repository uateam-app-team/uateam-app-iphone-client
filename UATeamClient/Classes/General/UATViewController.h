//
//  UATViewController.h
//  UATeamClient
//
//  Created by Andriy Titov on 7/2/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UATViewController : UIViewController {
    
    @protected
    MBProgressHUD *activityView;
    
}

- (void) startAnimatingActivityView;

- (void) stopAnimatingActivityView;

@end
