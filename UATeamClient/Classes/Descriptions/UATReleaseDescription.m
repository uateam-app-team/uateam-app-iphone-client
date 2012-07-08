//
//  UATReleaseDescription.m
//  UATeamClient
//
//  Created by Andrii Titov on 7/1/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
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
