//
//    UATReleaseInfoVC.h
//    UATeamClient
//
//    This file is part of UATeamClient.
//    UATeamClient is designed to give fast access to freshest releases on
//    <http://uateam.ua>.
//    Copyright (c) 2012 Andrii Titov. All rights reserved.
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
