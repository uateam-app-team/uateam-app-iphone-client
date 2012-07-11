//
//  UATSitcomInfo.m
//  UATeamClient
//
//  Created by Andrii Titov on 7/10/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import "UATSitcomInfo.h"
#import "HTMLParser.h"
#import "UATSitcomDescription.h"
#import "UATSitcomSeason.h"
#import "UATReleaseInfoVC.h"

@interface UATSitcomInfo ()

@end

@implementation UATSitcomInfo

@synthesize detailsURL;

- (void)loadReleases {
    NSError *initError = nil;
    NSURL *releaseURL = [NSURL URLWithString:self.detailsURL relativeToURL:HOME_URL];
    HTMLParser *freshParser = [[HTMLParser alloc] initWithContentsOfURL:releaseURL error:&initError];
    if (initError) {
        NSLog(@"%@",initError);
    }
    HTMLNode *tableNode = [freshParser.body findChildOfClass:@"adminlist"];
    sitDescription = [[UATSitcomDescription alloc] initWithHTMLNode:tableNode];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self loadReleases];
    [table reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark UITableView methods

//
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [sitDescription.seasons count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[(UATSitcomSeason *)[sitDescription.seasons objectAtIndex:section] episodeNames] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"episodeName"];
    cell.textLabel.text = [[[sitDescription.seasons objectAtIndex:indexPath.section] episodeNames] objectAtIndex:indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[sitDescription.seasons objectAtIndex:section] seasonName];
}

#pragma mark Segue prep

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"releaseInfo"]) {
        NSIndexPath *indexPath =[table indexPathForSelectedRow];
        UATReleaseInfoVC *releaseVC = [segue destinationViewController];
        releaseVC.detailsURL = [[[sitDescription.seasons objectAtIndex:indexPath.section] episodeLinks] objectAtIndex:indexPath.row];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
