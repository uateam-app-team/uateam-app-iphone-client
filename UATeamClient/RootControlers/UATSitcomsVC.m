//
//  UATSecondViewController.m
//  UATeamClient
//
//  Created by Andrii Titov on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UATSitcomsVC.h"
#import "HTMLParser.h"
#import "UATOtherReleases.h"

@interface UATSitcomsVC ()

@end

@implementation UATSitcomsVC

- (void)loadReleases {
    NSError *initError = nil;
    NSURL *sitcoms = HOME_URL;
    HTMLParser *freshParser = [[HTMLParser alloc] initWithContentsOfURL:sitcoms error:&initError];
    if (initError) {
        NSLog(@"%@",initError);
    }
    HTMLNode *tableNode;
    NSArray *headersArr = [freshParser.body findChildTags:@"h3"];
    for (HTMLNode *head in headersArr) {
        if ([[head contents] isEqualToString:@"Багатосерійні"]) {
            tableNode = [[head nextSibling] nextSibling];
            break;
        }
    }
    NSArray *tmpArray = [tableNode findChildTags:@"tr"];
    NSInteger cnt = [tmpArray count];
    sitcomReleases = [[NSMutableArray alloc] initWithCapacity:cnt];
    UATOtherReleases *release;
    for (HTMLNode *node in tmpArray) {
        release = [[UATOtherReleases alloc] initWithHTMLNode:node];
        [sitcomReleases addObject:release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    return [sitcomReleases count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"freshCell";
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
    cell.textLabel.text = [[sitcomReleases objectAtIndex:row] title];
    return cell;
}

#pragma mark

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
