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



static NSString *leftCellIdentifier = @"AKLeftSideResultCell";
static NSString *rightCellIdentifier = @"AKRightSideResultCell";

@interface AKResultsDataSource ()
{
    BOOL _isMirrorOddEven;
}

@property (nonatomic,strong) NSArray *resultsArr;

@end


@implementation AKResultsDataSource

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
    
    if (indexPath.item < [[self resultsArr]count]) {

        if ([[self resultsArr][indexPath.item] conformsToProtocol:@protocol(AKSearchAPIResultElementProtocol)]) {
            id<AKSearchAPIResultElementProtocol> entity = [self resultsArr][indexPath.item];
            
            [cell.titleLbl setText:[entity titleString]];
            [cell.subtitleLbl setText:[entity subtitleString]];
        }
    }
    
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122.0f;
}

@end
