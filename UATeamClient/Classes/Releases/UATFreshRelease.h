//
//  UATFreshRelease.h
//  UATeamClient
//
//  Created by Andrii Titov on 6/24/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UATAbstractRelease.h"

@interface UATFreshRelease : UATAbstractRelease {
    
}

@property (nonatomic, strong) NSString *categoryAndChunk;

@property (nonatomic, strong) NSString *imgPath;

@end
