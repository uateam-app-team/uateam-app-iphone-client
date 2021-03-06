//
//  UATFirstViewController.m
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

#import "UATNewVC.h"
#import "HTMLParser.h"
#import "UATFreshRelease.h"
#import "UATReleaseInfoVC.h"

@interface UATNewVC ()

@end

@implementation UATNewVC

- (void)loadReleases {
    NSError *initError = nil;
    NSURL *home = HOME_URL;
    HTMLParser *freshParser = [[HTMLParser alloc] initWithContentsOfURL:home error:&initError];
    if (initError) {
        NSLog(@"%@",initError);
    }
    NSArray *tmpArray = [freshParser.body findChildrenOfClass:@"freshrelease"];
    NSInteger cnt = [tmpArray count];
    freshReleases = [[NSMutableArray alloc] initWithCapacity:cnt];
    releaseImages = [[NSMutableArray alloc] initWithCapacity:cnt];
    imagesData = [[NSMutableArray alloc] initWithCapacity:cnt];
    UATFreshRelease *release;
    loadedImages = 0;
    for (HTMLNode *node in tmpArray) {
        release = [[UATFreshRelease alloc] initWithHTMLNode:node];
        NSURL *tmpURL = [NSURL URLWithString:release.imgPath relativeToURL:HOME_URL];
        NSURLRequest *tmpRequest = [NSURLRequest requestWithURL:tmpURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLConnection *tmpConnection = [NSURLConnection connectionWithRequest:tmpRequest delegate:self];
            [imagesData addObject:[[NSMutableData alloc] init]];
            [releaseImages addObject:tmpConnection];
            [tmpConnection start];
        });
        [freshReleases addObject:release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - URL loading routine

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
    NSInteger index = [releaseImages indexOfObject:connection];
    ++loadedImages;
    [releaseImages replaceObjectAtIndex:index withObject:[NSNull null]];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSInteger index = [releaseImages indexOfObject:connection];
    [[imagesData objectAtIndex:index] appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSInteger index = [releaseImages indexOfObject:connection];
    NSIndexPath *inPath = [NSIndexPath indexPathForRow:index inSection:0];
    UIImage *tmpImage = [UIImage imageWithData:[imagesData objectAtIndex:index]];
    [releaseImages replaceObjectAtIndex:index withObject:tmpImage];
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:inPath] withRowAnimation:UITableViewRowAnimationNone];
    [imagesData replaceObjectAtIndex:index withObject:[NSNull null]];
    ++loadedImages;
    if (loadedImages == [imagesData count]) {
        imagesData = nil;
    }
}

#pragma mark - UITableView methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [freshReleases count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"freshCell";
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    id im;
    if ([(im = [releaseImages objectAtIndex:row]) isKindOfClass:[UIImage class]]) {
        cell.imageView.image = im;
    }
    cell.textLabel.text = [[freshReleases objectAtIndex:row] categoryAndChunk];
    cell.detailTextLabel.text = [[freshReleases objectAtIndex:row] title];
    return cell;
}

#pragma mark Segue prep

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"releaseInfo"]) {
        NSInteger selectedRowIndex = [table indexPathForSelectedRow].row;
        UATReleaseInfoVC *releaseVC = [segue destinationViewController];
        releaseVC.detailsURL = [[freshReleases objectAtIndex:selectedRowIndex] detailsLink];
    }
}

#pragma mark

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
