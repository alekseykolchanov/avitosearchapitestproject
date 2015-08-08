//
//  AKSearchAPIProtocol.h
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

typedef void(^SuccessUpdateBlock)(NSString *searchStr, NSArray *searchResult);
typedef void(^FailUpdateBlock)(NSString *searchStr, NSError *error);

#pragma mark - AKSearchAPIResultElementProtocol
@protocol AKSearchAPIResultElementProtocol <NSObject>

-(NSString*)imageURLString;
-(NSString*)titleString;
-(NSString*)subtitleString;

@end


#pragma mark - AKSearchAPIProtocol
@protocol AKSearchAPIProtocol <NSObject>

-(void)setSearchString:(NSString*)searchStr;
-(void)setSuccessUpdateBlock:(SuccessUpdateBlock)successUpdateBlock;

@optional
-(void)setFailUpdateBlock:(FailUpdateBlock)failUpdateBlock;

@end