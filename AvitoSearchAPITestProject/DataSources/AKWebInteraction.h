//
//  AKWebInteraction.h
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^webInteractionCompletion)(NSData *responseData, NSError *error);


static NSString *const WEB_INTERACTION_ERROR_DOMAIN;


@interface AKWebInteraction : NSObject

+(instancetype)sharedInstance;

-(id)initInstance;

-(void)performURLRequest:(NSURLRequest*)request withCompletion:(webInteractionCompletion)completion;
-(void)cancelAllRequests;

@end
