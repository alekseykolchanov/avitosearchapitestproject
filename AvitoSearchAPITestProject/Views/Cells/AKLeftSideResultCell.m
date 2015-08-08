//
//  AKLeftSideResultCell.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKLeftSideResultCell.h"

@implementation AKLeftSideResultCell


-(void)buildView
{
    
    UIImageView *mIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [mIV setBackgroundColor:[UIColor colorWithWhite:0.95f alpha:1.0f]];
    mIV.layer.borderColor = [UIColor colorWithWhite:0.95f alpha:1.0f].CGColor;
    mIV.layer.borderWidth = 0.5f;
    [self.contentView addSubview:mIV];
    [mIV setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setIconIV:mIV];
    
    
    UILabel *mLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    [mLbl setTextColor:[UIColor blackColor]];
    [mLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    [mLbl setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:mLbl];
    [mLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setTitleLbl:mLbl];
    
    UILabel *stLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    [stLbl setTextColor:[UIColor blackColor]];
    [stLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [stLbl setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:stLbl];
    [stLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setSubtitleLbl:stLbl];

    
    NSDictionary *viewsDict = @{@"mIV":mIV,@"mLbl":mLbl, @"stLbl":stLbl};
    [[self contentView]addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(15)-[mIV(==92)]" options:0 metrics:nil views:viewsDict]];
    [[self contentView]addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[mIV(==92)]-(15)-[mLbl]-(>=8)-|" options:0 metrics:nil views:viewsDict]];
    
    [[self contentView]addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[mLbl]-(4)-[stLbl]" options:0 metrics:nil views:viewsDict]];
    [[self contentView]addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[stLbl]-(>=8)-|" options:0 metrics:nil views:viewsDict]];
    

    [[self contentView]addConstraint:[NSLayoutConstraint constraintWithItem:mLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mIV attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    
    [[self contentView]addConstraint:[NSLayoutConstraint constraintWithItem:stLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:mLbl attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    
}


@end
