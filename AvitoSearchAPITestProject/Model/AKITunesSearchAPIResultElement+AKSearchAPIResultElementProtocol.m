//
//  AKITunesSearchAPIResultElement+AKSearchAPIResultElementProtocol.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKITunesSearchAPIResultElement+AKSearchAPIResultElementProtocol.h"

@implementation AKITunesSearchAPIResultElement (AKSearchAPIResultElementProtocol)

-(NSString*)imageURLString
{
    return [self artworkUrl100];
}

-(NSString*)titleString
{
    return [self trackName];
}

-(NSString*)subtitleString
{
    return [self artistName];
}

@end
