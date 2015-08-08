//
//  AKGitHubSearchAPIResultElement+AKSearchAPIResultElementProtocol.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKGitHubSearchAPIResultElement+AKSearchAPIResultElementProtocol.h"

@implementation AKGitHubSearchAPIResultElement (AKSearchAPIResultElementProtocol)

-(NSString*)imageURLString
{
    return [self avatar_url];
}

-(NSString*)titleString
{
    return [self login];
}

-(NSString*)subtitleString
{
    return [self url];
}

@end
