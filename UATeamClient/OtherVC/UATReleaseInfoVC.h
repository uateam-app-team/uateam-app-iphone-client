//
//  UATReleaseInfoVC.h
//  UATeamClient
//
//  Created by Andrii Titov on 7/8/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UATViewController.h"
@class UATReleaseDescription;

@interface UATReleaseInfoVC : UATViewController<UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
    
    IBOutlet UITableView *table;
    
    IBOutlet UIImageView *releaseImage;
    
    IBOutlet UITextView *releaseDescription;
    
    UATReleaseDescription *relDescription;
    
    UIImage *coverImage;
    
    NSMutableData *imageData;
    
    NSString *videoUrl;
    
}

-(IBAction)buttonPressed:(id)sender;

@property (nonatomic, strong) NSString *detailsURL;

@end
