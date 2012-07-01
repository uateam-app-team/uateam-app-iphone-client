//
//  UATCartoonsVC.h
//  UATeamClient
//
//  Created by Andrii Titov on 6/24/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UATCartoonsVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *cartoonReleases;
    
    IBOutlet UITableView *table;
    
}

@end
