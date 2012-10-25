//
//  UATCartoonsVC.m
//  UATeamClient
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
//

#import "UATCartoonsVC.h"
#import "HTMLParser.h"
#import "UATOtherReleases.h"
#import "UATReleaseInfoVC.h"

@interface UATCartoonsVC ()

@end

@implementation UATCartoonsVC

- (void)loadReleases {
    NSError *initError = nil;
    NSURL *movies = [NSURL URLWithString:@"cartoons" relativeToURL:HOME_URL];
    HTMLParser *freshParser = [[HTMLParser alloc] initWithContentsOfURL:movies error:&initError];
    if (initError) {
        NSLog(@"%@",initError);
    }
    HTMLNode *tableNode = [freshParser.body findChildOfClass:@"adminlist"];
    NSArray *tmpArray = [[tableNode findChildTag:@"tbody"] findChildTags:@"tr"];
    NSInteger cnt = [tmpArray count];
    cartoonReleases = [[NSMutableArray alloc] initWithCapacity:cnt];
    UATOtherReleases *release;
    for (HTMLNode *node in tmpArray) {
        release = [[UATOtherReleases alloc] initWithHTMLNode:node];
        [cartoonReleases addObject:release];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    [self startAnimatingActivityView];
    dispatch_async(queue, ^{
        [self loadReleases];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [table reloadData];
            [self stopAnimatingActivityView];
        });
    });
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - UITableView methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cartoonReleases count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"freshCell";
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
//    id im;
//    if ([(im = [releaseImages objectAtIndex:row]) isKindOfClass:[UIImage class]]) {
//        cell.imageView.image = im;
//    }
    cell.textLabel.text = [[cartoonReleases objectAtIndex:row] title];
    return cell;
}

#pragma mark Segue prep

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"releaseInfo"]) {
        NSInteger selectedRowIndex = [table indexPathForSelectedRow].row;
        UATReleaseInfoVC *releaseVC = [segue destinationViewController];
        releaseVC.detailsURL = [[cartoonReleases objectAtIndex:selectedRowIndex] detailsLink];
        //        DetailViewController *detailViewController = [segue destinationViewController];
        //        detailViewController.play = [dataController objectInListAtIndex:selectedRowIndex.row];
    }
}

#pragma mark

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
