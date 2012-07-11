//
//  UATSitcomDescription.h
//  UATeamClient
//
//  Created by Andrii Titov on 7/9/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTMLNode;

@interface UATSitcomDescription : NSObject

-(id)initWithHTMLNode:(HTMLNode *)node;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray *seasons;

@end
