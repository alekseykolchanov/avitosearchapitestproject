//
//  AKImageCache.h
//  AvitoSearchAPITestProject
//
//  Created by Пользователь on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKImageCachedDataSource : NSObject

-(UIImage*)imageWithURLString:(NSString*)urlString;
-(void)downloadImageWithURLString:(NSString*)urlString withCompletion:(void(^)(NSString *urlString, UIImage* resImage))completion;
-(void)addImage:(UIImage*)image withURLString:(NSString*)urlString;


-(void)cancelAllDownloads;

@end
