//
//  UATReleaseInfoVC.m
//  UATeamClient
//
//  Created by Andrii Titov on 7/8/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import "UATReleaseInfoVC.h"
#import "HTMLParser.h"
#import "UATReleaseDescription.h"

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
        NSLog(@"%@",[pNode allContents]);
        if ([[pNode allContents] rangeOfString:@"Дата виходу:"].location != NSNotFound) {
            infoNode = pNode;
            break;
        }
    }
    if (!infoNode) {
        NSArray *pArray = [freshParser.body findChildTags:@"div"];
        for (HTMLNode *divNode in pArray) {
            NSLog(@"%@",[divNode allContents]);
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
    self.navigationController.navigationBarHidden = NO;
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

#pragma mark

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end