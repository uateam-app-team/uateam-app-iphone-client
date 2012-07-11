//
//  UATSitcomDescription.m
//  UATeamClient
//
//  Created by Andrii Titov on 7/9/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import "UATSitcomDescription.h"
#import "HTMLNode.h"
#import "UATSitcomSeason.h"

@implementation UATSitcomDescription

@synthesize title, seasons;

-(id)initWithHTMLNode:(HTMLNode *)node {
    self = [super init];
    if (self) {
        NSArray *headings = [node findChildrenOfClass:@"seasonheading"];
        NSMutableArray *seasArray = [[NSMutableArray alloc] initWithCapacity:[headings count]];
        UATSitcomSeason *season;
        @autoreleasepool {
            for (HTMLNode *trNode in headings) {
                season = [[UATSitcomSeason alloc] init];
                season.seasonName = [trNode allContents];
                HTMLNode *tmpNode = [trNode nextSibling];
                NSString *classStr;
                NSMutableArray *episodesM = [[NSMutableArray alloc] init];
                NSMutableArray *episodesL = [[NSMutableArray alloc] init];
                while ((nil != tmpNode->_node) && (![(classStr = [tmpNode getAttributeNamed:@"class"]) isEqualToString:@"seasonheading"])) {
                    if ([classStr isEqualToString:@"row0"] || [classStr isEqualToString:@"row1"]) {
                        NSArray *tds = [tmpNode findChildTags:@"td"];
                        [episodesM addObject:[[tds objectAtIndex:1] allContents]];
                        [episodesL addObject:[[tmpNode findChildTag:@"a"] getAttributeNamed:@"href"]];
                    }
                    tmpNode = tmpNode.nextSibling;
                }
                season.episodeNames = [episodesM copy];
                season.episodeLinks = [episodesL copy];
                [seasArray addObject:season];
            }
        }
        seasons = [seasArray copy];
    }
    return self;
}

@end
