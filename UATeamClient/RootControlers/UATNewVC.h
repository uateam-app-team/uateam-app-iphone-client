//
//  UATFirstViewController.h
//  UATeamClient
//
//  Created by Andrii Titov on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UATViewController.h"

@interface UATNewVC : UATViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
    
    NSMutableArray *freshReleases;
    
    NSMutableArray *releaseImages;
    
    NSMutableArray *imagesData;
    
    IBOutlet UITableView *table;
    
    NSInteger loadedImages;
    
}

@end
