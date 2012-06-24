//
//  UATFreshRelease.h
//  UATeamClient
//
//  Created by Andrii Titov on 6/24/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTMLNode;

@interface UATFreshRelease : NSObject {
    
}

-(id)initWithHTMLNode:(HTMLNode *)node;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *categoryAndChunk;

@property (nonatomic, strong) NSString *imgPath;

@property (nonatomic, strong) NSString *detailsLink;

@end
