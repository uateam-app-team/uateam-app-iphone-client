//
//  UATReleaseDescription.m
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

#import "UATReleaseDescription.h"
#import "HTMLNode.h"

@implementation UATReleaseDescription

@synthesize description,name,cast,category,genre,country,director,imageSrc,releaseDate;

-(id)initWithHTMLNode:(HTMLNode *)node {
    self = [super init];
    if (self) {
        NSArray *spans = [node findChildTags:@"span"];
        for (NSInteger i = 0; i < [spans count]; ++i) {
            NSString *title = [[spans objectAtIndex:i] allContents];
            NSString *value = [[[spans objectAtIndex:i] nextSibling] allContents];
            if ([title isEqualToString:@"Жанр:"]) {
                self.genre = value;
            }
            else if ([title isEqualToString:@"Країна:"]) {
                self.country = value;
            }
            else if ([title isEqualToString:@"Дата виходу:"]) {
                self.releaseDate = value;
            }
            else if ([title isEqualToString:@"Режисер:"]) {
                self.director = value;
            }
            else if ([title isEqualToString:@"У ролях:"]) {
                self.cast = value;
            }
            else if ([title isEqualToString:@"Опис"]) {
                self.description = value;
            }
        }
    }
    return self;
}

@end
