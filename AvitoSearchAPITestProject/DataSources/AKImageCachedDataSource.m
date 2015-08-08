//
//  AKImageCache.m
//  AvitoSearchAPITestProject
//
//  Created by Пользователь on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKImageCachedDataSource.h"
#import "AKWebInteraction.h"

@implementation AKImageCachedDataSource
{
    NSMutableDictionary *imageDictionary;
    dispatch_queue_t concurrentQueue;
    AKWebInteraction *webInteractionInstance;
}

-(id)init {
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
        concurrentQueue = dispatch_queue_create("imageCacheQueue", DISPATCH_QUEUE_CONCURRENT);
        webInteractionInstance = [[AKWebInteraction alloc]initInstance];
        
    }
    
    return self;
}

-(void)didReceiveMemoryWarning
{
    dispatch_barrier_async(concurrentQueue, ^{
        imageDictionary = [NSMutableDictionary new];
    });
}

#pragma mark - Access to images
-(UIImage*)imageWithURLString:(NSString*)urlString
{
    if (!urlString)
        return nil;
    
    __block UIImage *resImage = nil;
    
    dispatch_sync(concurrentQueue, ^{
        resImage = imageDictionary[urlString];
    });
    
    return resImage;
}

-(void)downloadImageWithURLString:(NSString*)urlString withCompletion:(void(^)(NSString *urlString, UIImage* resImage))completion {
    
    NSURLRequest *request = [self urlRequestWithImageURLSting:urlString];
    
    if (!request){
        
        if (completion)
            completion(urlString, nil);
        
        return;
    }
    
    [webInteractionInstance performURLRequest:request withCompletion:^(NSData *responseData, NSError *error) {
        
        UIImage *image;
        if (!error) {

            image = [UIImage imageWithData:responseData];

        }
        
        if (completion)
            completion(urlString,image);
        
        if (urlString && image) {
            [self addImage:image withURLString:urlString];
        }
    }];
    
}

-(void)addImage:(UIImage*)image withURLString:(NSString*)urlString
{
    if (!image || !urlString)
        return;
    
    dispatch_barrier_async(concurrentQueue, ^{
        imageDictionary[urlString] = image;
    });
}


-(void)cancelAllDownloads
{
    [webInteractionInstance cancelAllRequests];
}


#pragma mark - Helpers
-(NSURLRequest*)urlRequestWithImageURLSting:(NSString*)urlString
{
    if (!urlString || [urlString isEqualToString:@""])
        return nil;
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    return request;
}




@end
