//
//  AKRightSideResultCell.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKRightSideResultCell.h"

@implementation AKRightSideResultCell

-(void)buildView
{
    
    [super buildView];
    
    
    NSDictionary *viewsDict = @{@"mIV":[self iconIV],@"mLbl":[self titleLbl], @"stLbl":[self subtitleLbl]};
    [[self contentView]addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(15)-[mIV(==92)]" options:0 metrics:nil views:viewsDict]];
    [[self contentView]addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[mLbl]-(>=8)-[mIV(==92)]-(8)-|" options:0 metrics:nil views:viewsDict]];
    
    [[self contentView]addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[mLbl]-(4)-[stLbl]" options:0 metrics:nil views:viewsDict]];
    [[self contentView]addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[stLbl]-(>=8)-[mIV]" options:0 metrics:nil views:viewsDict]];
    
    
    [[self contentView]addConstraint:[NSLayoutConstraint constraintWithItem:[self titleLbl] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self iconIV] attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    
    [[self contentView]addConstraint:[NSLayoutConstraint constraintWithItem:[self subtitleLbl] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self titleLbl] attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    
}

@end
