//
//  UATSitcomInfo.h
//  UATeamClient
//
//  Created by Andrii Titov on 7/10/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UATSitcomDescription;

@interface UATSitcomInfo : UIViewController<UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
    
    UATSitcomDescription *sitDescription;
    
    IBOutlet UITableView *table;
    
}

@property (nonatomic, strong) NSString *detailsURL;

@end
