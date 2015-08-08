//
//  AKResultsDataSource.h
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AKResultsDataSource;

@protocol AKResultsDataSourceDelegate <NSObject>

@optional
-(void)resultsDataSource:(AKResultsDataSource*)resultsDataSource didTapOnIconImageView:(UIImageView*)iconImageView;

@end



@interface AKResultsDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *mainTV;

@property (nonatomic,weak) id<AKResultsDataSourceDelegate> delegate;

-(void)updateResultsWithArray:(NSArray*)array andMirrorOddEvenFlag:(BOOL)isMirrorOddEven;


@end
