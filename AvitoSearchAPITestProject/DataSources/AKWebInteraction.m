//
//  AKWebInteraction.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKWebInteraction.h"
#import <UIKit/UIKit.h>


static NSString *const WEB_INTERACTION_ERROR_DOMAIN = @"WEB_INTERACTION_ERROR_DOMAIN";

@interface AKWebInteraction ()<NSURLSessionDelegate>

@property (nonatomic,strong) NSURLSession *mainURLSession;

@end


@implementation AKWebInteraction

+(instancetype)sharedInstance

{
    static dispatch_once_t once;
    static AKWebInteraction *sharedInst;
    dispatch_once(&once,^{
        sharedInst = [[self alloc]init];
    });
    return sharedInst;
}

-(id)initInstance
{
    if (self = [super init]){
    
    }
    
    return self;
}

-(NSURLSession *)mainURLSession
{
    if (!_mainURLSession)
    {
        NSURLSessionConfiguration *myConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [myConfiguration setAllowsCellularAccess:YES];
        [myConfiguration setURLCache:nil];
        [myConfiguration setHTTPMaximumConnectionsPerHost:2];
        [myConfiguration setTimeoutIntervalForRequest:30.0f];
        _mainURLSession = [NSURLSession sessionWithConfiguration:myConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return _mainURLSession;
}

#pragma  mark NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"URLSession:didBecomeInvalidWithError:%@",[error localizedDescription]);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{

     if (completionHandler)
     completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession:");
}




-(void)performURLRequest:(NSURLRequest*)request withCompletion:(webInteractionCompletion)completion
{
    NSURLSessionDataTask *dTask = [[self mainURLSession]dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!completion)
            return;
        
        if (error) {
            completion(nil,error);
        }else {
            NSError *statusError;
            if ([response isKindOfClass:[NSHTTPURLResponse class]]){
                int statusCode = [(NSHTTPURLResponse*)response statusCode];
                if  (statusCode<200 || statusCode>=300) {
                    NSString *errorString = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
                    if (!errorString)
                        errorString = [NSString stringWithFormat:@"HTTP Status code = %d. URL = %@",statusCode, [response URL]];
                        
                    NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : errorString };
                    statusError = [[NSError alloc] initWithDomain:WEB_INTERACTION_ERROR_DOMAIN
                                                                code:statusCode
                                                            userInfo:userInfoDict];
                }
            }
            
            completion(data,statusError);
        }
        
    }];
    [dTask resume];
}


-(void)cancelAllRequests
{
    [[self mainURLSession]getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        [dataTasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
            [task cancel];
        }];
        
        [uploadTasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
            [task cancel];
        }];
        
        [downloadTasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
            [task cancel];
        }];
    }];
}

@end
