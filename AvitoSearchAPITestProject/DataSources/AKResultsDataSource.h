//
//  AKResultsDataSource.h
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKResultsEntity

@property (nonatomic,copy) NSString *imageURLString;
@property (nonatomic,copy) NSString *titleString;
@property (nonatomic,copy) NSString *subtitleString;

@end


@interface AKResultsDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *mainTV;

-(void)updateResultsWithArray:(NSArray*)array andMirrorOddEvenFlag:(BOOL)isMirrorOddEven;

@end
