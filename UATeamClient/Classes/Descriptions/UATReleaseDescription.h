//
//  UATReleaseDescription.h
//  UATeamClient
//
//  Created by Andrii Titov on 7/1/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTMLNode;

@interface UATReleaseDescription : NSObject

-(id)initWithHTMLNode:(HTMLNode *)node;

@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) NSString *genre;

@property (nonatomic, strong) NSString *director;

@property (nonatomic, strong) NSString *cast;

@property (nonatomic, strong) NSString *imageSrc;

@property (nonatomic, strong) NSString *releaseDate;

@end
