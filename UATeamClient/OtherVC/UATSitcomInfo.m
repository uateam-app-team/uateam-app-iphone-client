//
//  UATSitcomInfo.m
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

#import "UATSitcomInfo.h"
#import "HTMLParser.h"
#import "UATSitcomDescription.h"
#import "UATSitcomSeason.h"
#import "UATReleaseInfoVC.h"

@interface UATSitcomInfo ()

@end

@implementation UATSitcomInfo {
    
    UIImage *coverImage;
    
    NSMutableData *imageData;
    
}

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
    HTMLNode *imageNode = [[freshParser.body findChildrenWithAttribute:@"id" matchingName:@"catimage" allowPartial:NO] objectAtIndex:0];
    sitDescription.imageSource = [imageNode getAttributeNamed:@"src"];
    NSURL *imURL = [NSURL URLWithString:sitDescription.imageSource relativeToURL:HOME_URL];
    NSURLRequest *tmpRequest = [NSURLRequest requestWithURL:imURL];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLConnection *tmpConnection = [NSURLConnection connectionWithRequest:tmpRequest delegate:self];
        [tmpConnection start];
    });
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

#pragma mark - URL loading routine

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    imageData = [[NSMutableData alloc] initWithCapacity:[response expectedContentLength]];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [imageData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    coverImage = [UIImage imageWithData:imageData];
    imageData = nil;
    catImage.image = coverImage;
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
