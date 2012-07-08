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
#import "UATReleaseInfoVC.h"

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
//    id im;
//    if ([(im = [releaseImages objectAtIndex:row]) isKindOfClass:[UIImage class]]) {
//        cell.imageView.image = im;
//    }
    //cell.textLabel.text = [[movieReleases objectAtIndex:row] description];
    cell.textLabel.text = [[movieReleases objectAtIndex:row] title];
    return cell;
}

#pragma mark Segue prep

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"releaseInfo"]) {
        NSInteger selectedRowIndex = [table indexPathForSelectedRow].row;
        UATReleaseInfoVC *releaseVC = [segue destinationViewController];
        releaseVC.detailsURL = [[movieReleases objectAtIndex:selectedRowIndex] detailsLink];
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
