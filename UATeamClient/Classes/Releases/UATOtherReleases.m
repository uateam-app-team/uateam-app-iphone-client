//
//  UATOtherReleases.m
//  UATeamClient
//
//  Created by Andrii Titov on 7/1/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import "UATOtherReleases.h"
#import "HTMLNode.h"

@implementation UATOtherReleases

-(id)initWithHTMLNode:(HTMLNode *)node {
    self = [super initWithHTMLNode:node];
    if (self) {
        NSArray *tableCols = [node findChildTags:@"td"];
        for (HTMLNode *td in tableCols) {
            if ([[[td firstChild] allContents] length] > 1) {
                HTMLNode *a = [td firstChild];
                self.title = [a allContents];
                self.detailsLink = [a getAttributeNamed:@"href"];
                break;
            }
        }
    }
    return self;
}


@end
