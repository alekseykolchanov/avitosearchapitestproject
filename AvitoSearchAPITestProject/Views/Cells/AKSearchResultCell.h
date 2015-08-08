//
//  AKSearchResultCell.h
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AKSearchResultCell;

@protocol AKSearchResultCellDelegate <NSObject>

@optional
-(void)didTapOnIconInSearchResultCell:(AKSearchResultCell*)cell;

@end

@interface AKSearchResultCell : UITableViewCell

@property (nonatomic,copy) NSString *iconURLString;

@property (nonatomic,weak) UIImageView *iconIV;
@property (nonatomic,weak) UILabel *titleLbl;
@property (nonatomic,weak) UILabel *subtitleLbl;

@property (nonatomic,weak) id<AKSearchResultCellDelegate>delegate;

-(void)buildView;

@end
