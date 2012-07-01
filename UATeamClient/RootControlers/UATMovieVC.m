//
//  UATMovieVC.m
//  UATeamClient
//
//  Created by Andrii Titov on 6/24/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import "UATMovieVC.h"
#import "HTMLParser.h"
#import "UATOtherReleases.h"

@interface UATMovieVC ()

@end

@implementation UATMovieVC

- (void)loadReleases {
    NSError *initError = nil;
    NSURL *movies = [NSURL URLWithString:@"movies" relativeToURL:HOME_URL];
    HTMLParser *freshParser = [[HTMLParser alloc] initWithContentsOfURL:movies error:&initError];
    if (initError) {
        NSLog(@"%@",initError);
    }
    HTMLNode *tableNode = [freshParser.body findChildOfClass:@"adminlist"];
    NSArray *tmpArray = [[tableNode findChildTag:@"tbody"] findChildTags:@"tr"];
    NSInteger cnt = [tmpArray count];
    movieReleases = [[NSMutableArray alloc] initWithCapacity:cnt];
    UATOtherReleases *release;
    for (HTMLNode *node in tmpArray) {
        release = [[UATOtherReleases alloc] initWithHTMLNode:node];
        [movieReleases addObject:release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadReleases];
    [table reloadData];
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
    return [movieReleases count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"movieCell";
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
//    id im;
//    if ([(im = [releaseImages objectAtIndex:row]) isKindOfClass:[UIImage class]]) {
//        cell.imageView.image = im;
//    }
    //cell.textLabel.text = [[movieReleases objectAtIndex:row] description];
    cell.textLabel.text = [[movieReleases objectAtIndex:row] title];
    return cell;
}

#pragma mark

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
