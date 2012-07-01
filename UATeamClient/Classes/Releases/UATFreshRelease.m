//
//  UATFreshRelease.m
//  UATeamClient
//
//  Created by Andrii Titov on 6/24/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import "UATFreshRelease.h"
#import "HTMLNode.h"

@implementation UATFreshRelease
@synthesize title, imgPath, detailsLink, categoryAndChunk;

-(id)initWithHTMLNode:(HTMLNode *)node {
    self = [super initWithHTMLNode:node];
    if (self) {
        NSString *category = [[node findChildTag:@"span"] allContents];
        NSString *part = [[node findChildTag:@"div"] allContents];
        self.categoryAndChunk = [NSString stringWithFormat:@"%@\t%@",category,part];
        self.title = [[node findChildOfClass:@"torrent_title"] allContents];
        self.imgPath = [(HTMLNode *)[node findChildOfClass:@"category_icon"] getAttributeNamed:@"src"];
        NSArray *refArray = [node findChildTags:@"a"];
        for (HTMLNode *refNode in refArray) {
            if ([[[refNode firstChild] getAttributeNamed:@"title"] isEqualToString:@"Деталі епізоду"]) {
                self.detailsLink = [refNode getAttributeNamed:@"href"];
                break;
            }
        }
    }
    return self;
}

@end
