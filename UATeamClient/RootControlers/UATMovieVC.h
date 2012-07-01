//
//  UATMovieVC.h
//  UATeamClient
//
//  Created by Andrii Titov on 6/24/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UATMovieVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *movieReleases;
    
    IBOutlet UITableView *table;
    
}

@end
