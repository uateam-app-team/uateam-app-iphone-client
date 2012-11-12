//
//  UATReleaseInfoVC.m
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

#import "UATReleaseInfoVC.h"
#import "HTMLParser.h"
#import "UATReleaseDescription.h"
#import "UATStreamingVC.h"

@interface UATReleaseInfoVC ()

@end

@implementation UATReleaseInfoVC
@synthesize detailsURL;

- (void)loadReleases {
    NSError *initError = nil;
    NSURL *releaseURL = [NSURL URLWithString:self.detailsURL relativeToURL:HOME_URL];
    HTMLParser *freshParser = [[HTMLParser alloc] initWithContentsOfURL:releaseURL error:&initError];
    if (initError) {
        NSLog(@"%@",initError);
    }
    NSArray *pArray = [freshParser.body findChildTags:@"p"];
    HTMLNode *infoNode = nil;
    for (HTMLNode *pNode in pArray) {
        //NSLog(@"%@",[pNode allContents]);
        if ([[pNode allContents] rangeOfString:@"Дата виходу:"].location != NSNotFound) {
            infoNode = pNode;
            break;
        }
    }
    if (!infoNode) {
        NSArray *pArray = [freshParser.body findChildTags:@"div"];
        for (HTMLNode *divNode in pArray) {
            //NSLog(@"%@",[divNode allContents]);
            if ([[divNode allContents] rangeOfString:@"Дата виходу:"].location != NSNotFound) {
                infoNode = divNode;
                break;
            }
        }
    }
    relDescription = [[UATReleaseDescription alloc] initWithHTMLNode:infoNode];
    HTMLNode *headerNode = [freshParser.body findChildTag:@"h2"].nextSibling.nextSibling;
    relDescription.name = [headerNode contents];
    HTMLNode *imgNode = [freshParser.body findChildOfClass:@"modal"];
    relDescription.imageSrc = [imgNode getAttributeNamed:@"href"];
    NSURL *imURL = [NSURL URLWithString:relDescription.imageSrc];
    NSURLRequest *tmpRequest = [NSURLRequest requestWithURL:imURL];
    HTMLNode *videoNode = [freshParser.body findChildWithAttribute:@"id" matchingName:@"online_code" allowPartial:NO];
    videoNode = [videoNode findChildWithAttribute:@"name" matchingName:@"flashvars" allowPartial:NO];
    NSString *tmpUrl = [videoNode getAttributeNamed:@"value"];
    if (tmpUrl) {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@".*file\\=((http|https|ftp)\\://[a-zA-Z0-9\\-\\.]+\\.[a-zA-Z]{2,3}/[a-zA-Z0-9\\-\\._/\\\\]+\\.mp4).*"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
        NSArray *matches = [regex matchesInString:tmpUrl options:0 range:NSMakeRange(0, [tmpUrl length])];
        for (NSTextCheckingResult *match in matches) {
            NSRange firstHalfRange = [match rangeAtIndex:1];
            videoUrl = [tmpUrl substringWithRange:firstHalfRange];
        }
        //videoUrl = @"http://km.support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1211/sample_iTunes.mov";
    }
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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    [self startAnimatingActivityView];
    dispatch_async(queue, ^{
        [self loadReleases];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.title = relDescription.name;
            [table reloadData];
            [self stopAnimatingActivityView];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    NSInteger row = indexPath.row;
    NSString *title = nil, *subtl = nil;
    switch (row) {
        case 0:
            title = relDescription.releaseDate;
            subtl = @"Release date";
            break;
        case 1:
            title = relDescription.country;
            subtl = @"Country";
            break;
        case 2:
            title = relDescription.genre;
            subtl = @"Genre";
            break;
        case 3:
            title = relDescription.director;
            subtl = @"Director";
            break;
        case 4:
            title = relDescription.cast;
            subtl = @"Cast";
            break;
        case 5:
            title = relDescription.category;
            subtl = @"Category";
            break;
        default:
            break;
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtl;
    return cell;
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
    releaseImage.image = coverImage;
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)buttonPressed:(id)sender {
    NSURL *_videoURL = [NSURL URLWithString:videoUrl];
    UATStreamingVC *streamer = [[UATStreamingVC alloc] initWithContentURL:_videoURL];
    [self.navigationController pushViewController:streamer animated:YES];
}

#pragma mark -

-(void)setTitle:(NSString *)title {
    [super setTitle:title];
    navBar.topItem.title = title;
}

@end
