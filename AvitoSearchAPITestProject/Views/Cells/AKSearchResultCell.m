//
//  AKSearchResultCell.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKSearchResultCell.h"

@implementation AKSearchResultCell
{
    UITapGestureRecognizer *_iconTapRecognizer;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleGray];
        [self buildView];
    }
    
    return self;
}

-(void)buildView {
    
    [[[self contentView]subviews]enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        [subView removeFromSuperview];
    }];
    
    UIImageView *mIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [mIV setBackgroundColor:[UIColor clearColor]];
    mIV.layer.shadowColor = [UIColor colorWithWhite:0.1f alpha:0.9f].CGColor;
    mIV.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    mIV.layer.shadowOpacity = 0.5f;
    mIV.layer.shadowRadius = 1.0f;
    [mIV setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:mIV];
    [mIV setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setIconIV:mIV];
    
    
    UILabel *mLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    [mLbl setTextColor:[UIColor blackColor]];
    [mLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    [mLbl setTextAlignment:NSTextAlignmentLeft];
    [mLbl setNumberOfLines:3];
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
    
    _iconTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnIconView:)];
    [mIV addGestureRecognizer:_iconTapRecognizer];
    [mIV setUserInteractionEnabled:YES];
}


-(void)prepareForReuse
{
    [self setIconURLString:nil];
    [[self iconIV]setHidden:NO];
    [[self iconIV]setImage:nil];
    [[self titleLbl]setText:nil];
    [[self subtitleLbl]setText:nil];
}


-(void)didTapOnIconView:(UIGestureRecognizer*)recognizer
{
    if ([[self delegate]respondsToSelector:@selector(didTapOnIconInSearchResultCell:)]){
        [[self delegate]didTapOnIconInSearchResultCell:self];
    }
}


@end
