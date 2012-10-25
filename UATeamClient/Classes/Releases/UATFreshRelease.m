//
//  UATFreshRelease.m
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

#import "UATFreshRelease.h"
#import "HTMLNode.h"

@implementation UATFreshRelease
@synthesize title, imgPath, detailsLink, categoryAndChunk;

-(id)initWithHTMLNode:(HTMLNode *)node {
    self = [super initWithHTMLNode:node];
    if (self) {
        NSString *category = [[node findChildTag:@"span"] allContents];
        NSString *part = [[node findChildTag:@"div"] allContents];
        self.categoryAndChunk = [NSString stringWithFormat:@"%@    %@",category,part];
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
