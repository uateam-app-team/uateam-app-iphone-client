//
//  UATAbstractRelease.m
//  UATeamClient
//
//  Created by Andrii Titov on 7/1/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import "UATAbstractRelease.h"

@implementation UATAbstractRelease
@synthesize title,detailsLink;

-(id)initWithHTMLNode:(HTMLNode *)node {
    //@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Direct usage of abstract class" userInfo:nil];
    return [super init];
}

@end
