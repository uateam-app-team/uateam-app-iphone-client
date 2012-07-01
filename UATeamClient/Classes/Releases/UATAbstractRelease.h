//
//  UATAbstractRelease.h
//  UATeamClient
//
//  Created by Andrii Titov on 7/1/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTMLNode;

@interface UATAbstractRelease : NSObject

-(id)initWithHTMLNode:(HTMLNode *)node;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *detailsLink;

@end
