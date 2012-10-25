//
//  UATSitcomDescription.m
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
