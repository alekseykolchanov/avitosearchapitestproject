//
//  AKResultsDataSource.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKResultsDataSource.h"
#import "AKSearchAPIProtocol.h"
#import "AKLeftSideResultCell.h"
#import "AKRightSideResultCell.h"
#import "AKITunesSearchAPIResultElement+AKSearchAPIResultElementProtocol.h"
#import "AKGitHubSearchAPIResultElement+AKSearchAPIResultElementProtocol.h"
#import "AKImageCachedDataSource.h"



static NSString *leftCellIdentifier = @"AKLeftSideResultCell";
static NSString *rightCellIdentifier = @"AKRightSideResultCell";

@interface AKResultsDataSource ()<AKSearchResultCellDelegate>
{
    BOOL _isMirrorOddEven;
    AKImageCachedDataSource *imageDataSource;
}

@property (nonatomic,strong) NSArray *resultsArr;

@end


@implementation AKResultsDataSource

-(id)init {
    if (self = [super init]){
        imageDataSource = [AKImageCachedDataSource new];
    }
    
    return self;
}

-(void)setMainTV:(UITableView *)mainTV
{
    _mainTV = mainTV;
    
    if (_mainTV) {
        
        [_mainTV registerClass:[AKLeftSideResultCell class] forCellReuseIdentifier:leftCellIdentifier];
        [_mainTV registerClass:[AKRightSideResultCell class] forCellReuseIdentifier:rightCellIdentifier];
        
        [_mainTV setDataSource:self];
        [_mainTV setDelegate:self];
        
    }
}

-(NSArray*)resultsArr
{
    if (!_resultsArr) {
        _resultsArr = @[];
    }
    
    return _resultsArr;
}

-(void)updateResultsWithArray:(NSArray*)array andMirrorOddEvenFlag:(BOOL)isMirrorOddEven
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [imageDataSource cancelAllDownloads];
        _isMirrorOddEven = isMirrorOddEven;
        [self setResultsArr:array];
        [[self mainTV]reloadData];
        
    });
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self resultsArr]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = leftCellIdentifier;
    if ((indexPath.item % 2 == 0 && _isMirrorOddEven)||(indexPath.item % 2 != 0 && !_isMirrorOddEven)) {
        identifier = rightCellIdentifier;
    }
    
    AKSearchResultCell *cell = (AKSearchResultCell *)[[self mainTV]dequeueReusableCellWithIdentifier:identifier];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

-(void)configureCell:(AKSearchResultCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell.iconIV setImage:nil];
    [cell.titleLbl setText:@""];
    [cell.subtitleLbl setText:@""];
    
    [cell setDelegate:self];
    
    if (indexPath.item < [[self resultsArr]count]) {

        if ([[self resultsArr][indexPath.item] conformsToProtocol:@protocol(AKSearchAPIResultElementProtocol)]) {
            id<AKSearchAPIResultElementProtocol> entity = [self resultsArr][indexPath.item];
            
            [cell.titleLbl setText:[entity titleString]];
            [cell.subtitleLbl setText:[entity subtitleString]];
            [cell setIconURLString:[entity imageURLString]];
            
            if ([entity imageURLString]){
                UIImage *img = [imageDataSource imageWithURLString:[entity imageURLString]];
                if (img){
                    [cell.iconIV setImage:img];
                }else{
                    [imageDataSource downloadImageWithURLString:[entity imageURLString] withCompletion:^(NSString *urlString, UIImage *resImage) {
                        if (resImage && urlString) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if ([cell iconURLString] && [[cell iconURLString]isEqualToString:urlString]){
                                    [cell.iconIV setImage:resImage];
                                    [cell.iconIV setAlpha:0.0f];
                                    [UIView animateWithDuration:0.12f animations:^{
                                        [cell.iconIV setAlpha:1.0f];
                                    }];
                                }
                            });
                        }
                    }];
                }
            }
        }
    }
    
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122.0f;
}


#pragma mark - AKSearchResultCellDelegate
-(void)didTapOnIconInSearchResultCell:(AKSearchResultCell *)cell
{
    if ([[self delegate]respondsToSelector:@selector(resultsDataSource:didTapOnIconImageView:)]){
        [[self delegate]resultsDataSource:self didTapOnIconImageView:[cell iconIV]];
    }
}

@end
