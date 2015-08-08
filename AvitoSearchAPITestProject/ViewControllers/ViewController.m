//
//  ViewController.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "ViewController.h"
#import "AKResultsDataSource.h"
#import "AKITunesSearchAPI.h"
#import "AKGitHubSearchAPI.h"

@interface ViewController ()<UISearchBarDelegate>
{
    __weak UISegmentedControl *_topSegmentedControl;
    __weak UIActivityIndicatorView *_topActivityIndicator;
    
    __weak UISearchBar *_searchBar;
    __weak UITableView *_resultsTableView;
    
    
    
    
    
}

@property (nonatomic,strong) AKResultsDataSource *resultsDataSource;

@property (nonatomic,strong) AKITunesSearchAPI *itunesSearchApi;
@property (nonatomic,strong) AKGitHubSearchAPI *gitHubSearchApi;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    [self setResultsDataSource:[AKResultsDataSource new]];
    [[self resultsDataSource] setMainTV:_resultsTableView];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"iTunes",@"GitHub"]];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [[self navigationItem]setTitleView:segmentedControl];
    _topSegmentedControl = segmentedControl;
    
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setHidesWhenStopped:YES];
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    [[self navigationItem]setLeftBarButtonItem:segmentBarItem];
    _topActivityIndicator = activityIndicator;
}


-(void)loadView
{
    [super loadView];
    
    //Search Bar
    UISearchBar *sBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    [sBar setDelegate:self];
    [sBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:sBar];
    _searchBar = sBar;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[sBar]-(0)-|" options:0 metrics:nil views:@{@"sBar":sBar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-(0)-[sBar]" options:0 metrics:nil views:@{@"topGuide":self.topLayoutGuide, @"sBar":sBar}]];
    
    
    //TableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    [tableView setAllowsSelection:NO];
    [tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:tableView];
    _resultsTableView = tableView;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[tableView]-(0)-|" options:0 metrics:nil views:@{@"tableView":tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sBar]-(0)-[tableView]-(0)-|" options:0 metrics:nil views:@{@"sBar":sBar,@"tableView":tableView}]];
    
    
}


-(AKITunesSearchAPI*)itunesSearchApi
{
    if (!_itunesSearchApi)
    {
        _itunesSearchApi = [AKITunesSearchAPI new];
        
        __weak ViewController *weakSelf = self;
        
        [_itunesSearchApi setSuccessUpdateBlock:^(NSString *searchStr, NSArray *searchResult){
            if ([weakSelf currentSearchApi]!= nil &&
                [weakSelf currentSearchApi] == [weakSelf itunesSearchApi]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([searchStr isEqualToString:[weakSelf cleanSearchString]]){
                        [weakSelf stopActivityAnimation];
                        [[weakSelf resultsDataSource]updateResultsWithArray:searchResult andMirrorOddEvenFlag:YES];
                    }
                    
                });
            }
        }];
        
        [_itunesSearchApi setFailUpdateBlock:^(NSString *searchStr, NSError *error){
            if ([weakSelf currentSearchApi]!= nil &&
                [weakSelf currentSearchApi] == [weakSelf itunesSearchApi]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([searchStr isEqualToString:[weakSelf cleanSearchString]]){
                        [weakSelf stopActivityAnimation];
                        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Ошибка" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [av show];
                    }
                    
                });
            }
        }];
    }
    
    return _itunesSearchApi;
}

-(AKGitHubSearchAPI*)gitHubSearchApi
{
    if (!_gitHubSearchApi){
        
        _gitHubSearchApi = [AKGitHubSearchAPI new];
        
        __weak ViewController *weakSelf = self;
        [_gitHubSearchApi setSuccessUpdateBlock:^(NSString *searchStr, NSArray *searchResult){
            if ([weakSelf currentSearchApi]!= nil &&
                [weakSelf currentSearchApi] == [weakSelf gitHubSearchApi]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([searchStr isEqualToString:[weakSelf cleanSearchString]]){
                        
                        [weakSelf stopActivityAnimation];
                        [[weakSelf resultsDataSource]updateResultsWithArray:searchResult andMirrorOddEvenFlag:NO];
                    }
                    
                });
            }
        }];
        
        [_gitHubSearchApi setFailUpdateBlock:^(NSString *searchStr, NSError *error){
            if ([weakSelf currentSearchApi]!= nil &&
                [weakSelf currentSearchApi] == [weakSelf gitHubSearchApi]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([searchStr isEqualToString:[weakSelf cleanSearchString]]){
                        [weakSelf stopActivityAnimation];
                        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Ошибка" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [av show];
                    }
                    
                });
            }
        }];
    }
    
    return _gitHubSearchApi;
}


-(id<AKSearchAPIProtocol>)currentSearchApi {
    switch ([_topSegmentedControl selectedSegmentIndex]) {
        case 0:
            return [self itunesSearchApi];
        case 1:
            return [self gitHubSearchApi];
    }
    
    return nil;
}

-(NSString *)cleanSearchString {
    return [[_searchBar text]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


-(void)startActivityAnimation
{
    [_topActivityIndicator startAnimating];
}

-(void)stopActivityAnimation
{
    [_topActivityIndicator stopAnimating];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([[self cleanSearchString]length]>0){
        [[self currentSearchApi]setSearchString:[self cleanSearchString]];
        [searchBar resignFirstResponder];
        [self startActivityAnimation];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[self resultsDataSource]updateResultsWithArray:@[] andMirrorOddEvenFlag:NO];
}

#pragma mark - SegmentedControl
-(void)segmentedControlValueChanged:(UISegmentedControl*)segmentedControl
{
    if (segmentedControl == _topSegmentedControl) {
        [[self resultsDataSource]updateResultsWithArray:@[] andMirrorOddEvenFlag:NO];
    }
}

@end
