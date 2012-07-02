//
//  UATSecondViewController.h
//  UATeamClient
//
//  Created by Andrii Titov on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UATViewController.h"

@interface UATSitcomsVC : UATViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *sitcomReleases;
    
    IBOutlet UITableView *table;
    
}

@end
