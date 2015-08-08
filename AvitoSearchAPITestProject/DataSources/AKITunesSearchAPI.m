//
//  AKITunesSearchAPI.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKITunesSearchAPI.h"
#import "AKWebInteraction.h"
#import "AKITunesSearchAPIResultElement+AKJsonInitProtocol.h"

static NSString *const itunesSearchAPIURL = @"https://itunes.apple.com/search";


@implementation AKITunesSearchAPI

@synthesize searchString = _searchString;

-(void)setSearchString:(NSString *)searchString
{
    _searchString = [searchString copy];
    
    NSURLRequest *request = [self urlRequestForSearchString:_searchString];
    
    NSString *searchStringCopy = _searchString.copy;
    if (request){
        [[AKWebInteraction sharedInstance]performURLRequest:request withCompletion:^(NSData *responseData, NSError *error) {
            if (!error){
                
                if (!responseData || responseData.length == 0){
                    if ([self successUpdateBlock])
                        [self successUpdateBlock](searchStringCopy,@[]);
                    return;
                }
                
            
                NSError *jsonParseError;
                NSDictionary *d = [NSJSONSerialization JSONObjectWithData:responseData
                                                                  options:0
                                                                    error:&jsonParseError];
                if (!d){
                    if ([self failUpdateBlock]) {
                        [self failUpdateBlock](searchStringCopy,jsonParseError);
                    }
                    return;
                }
                
                NSArray *jsonResArray = d[@"results"];
                if (!jsonResArray || ![jsonResArray isKindOfClass:[NSArray class]]) {
                    if ([self failUpdateBlock]) {
                        [self failUpdateBlock](searchStringCopy,nil);
                    }
                    return;
                }
                
                __block NSMutableArray *resArray = [NSMutableArray new];
                [jsonResArray enumerateObjectsUsingBlock:^(NSDictionary *elementDict, NSUInteger idx, BOOL *stop) {
                    AKITunesSearchAPIResultElement *element = [[AKITunesSearchAPIResultElement alloc]initWithJsonDict:elementDict];
                    if (element)
                        [resArray addObject:element];
                }];
                
                
                if ([self successUpdateBlock]){
                    [self successUpdateBlock](searchStringCopy, resArray);
                }
                
            }else{
                if ([self failUpdateBlock]){
                    [self failUpdateBlock](searchStringCopy,error);
                }
            }
        }];
    }else{
        if ([self successUpdateBlock])
            [self successUpdateBlock](searchStringCopy,@[]);
    }
}


-(NSURLRequest*)urlRequestForSearchString:(NSString*)searchString
{
    if (!searchString || [searchString isEqualToString:@""])
        return nil;
    
    NSString *percentEncodedSearchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (!percentEncodedSearchString)
        return nil;
    
    NSString *requestStr = [NSString stringWithFormat:@"%@?term=%@",itunesSearchAPIURL,percentEncodedSearchString];
    
    NSURL *url = [NSURL URLWithString:requestStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    return request;
    
}

@end
