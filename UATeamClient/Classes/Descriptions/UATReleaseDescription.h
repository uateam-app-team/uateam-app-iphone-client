//
//  UATReleaseDescription.h
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
