//
//  AKITunesSearchAPIResultElement+AKJsonInitProtocol.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKITunesSearchAPIResultElement+AKJsonInitProtocol.h"

@implementation AKITunesSearchAPIResultElement (AKJsonInitProtocol)

-(id)initWithJsonDict:(NSDictionary*)dict
{
    if (!dict)
        return nil;
    
    if (self = [super init])
    {
        [self setArtworkUrl100:dict[@"artworkUrl100"]];
        [self setTrackName:dict[@"trackName"]];
        [self setArtistName:dict[@"artistName"]];
        
    }
    
    return self;
}


@end
