//
//  AKITunesSearchAPI.h
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKSearchAPIProtocol.h"

static NSString *const itunesSearchAPIURL;


@interface AKITunesSearchAPI : NSObject<AKSearchAPIProtocol>


@property (nonatomic,copy) NSString *searchString;
@property (nonatomic,copy) SuccessUpdateBlock successUpdateBlock;
@property (nonatomic,copy) FailUpdateBlock failUpdateBlock;


@end
