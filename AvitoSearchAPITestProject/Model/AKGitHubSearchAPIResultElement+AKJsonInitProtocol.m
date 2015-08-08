//
//  AKGitHubSearchAPIResultElement+AKJsonInitProtocol.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKGitHubSearchAPIResultElement+AKJsonInitProtocol.h"

@implementation AKGitHubSearchAPIResultElement (AKJsonInitProtocol)

-(id)initWithJsonDict:(NSDictionary*)dict
{
    if (!dict)
        return nil;
    
    if (self = [super init])
    {
        [self setAvatar_url:dict[@"avatar_url"]];
        [self setLogin:dict[@"login"]];
        [self setUrl:dict[@"url"]];
        
    }
    
    return self;
}

@end
