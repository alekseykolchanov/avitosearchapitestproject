//
//  ViewController.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 08/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "ViewController.h"
#import "AKResultsDataSource.h"

@interface ViewController ()<UISearchBarDelegate>
{
    __weak UISegmentedControl *_topSegmentedControl;
    __weak UISearchBar *_searchBar;
    __weak UITableView *_resultsTableView;
    
    
    AKResultsDataSource *resultsDataSource;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    resultsDataSource = [AKResultsDataSource new];
    [resultsDataSource setMainTV:_resultsTableView];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"iTunes",@"GitHub"]];
    [segmentedControl setSelectedSegmentIndex:0];
    [[self navigationItem]setTitleView:segmentedControl];
    _topSegmentedControl = segmentedControl;
    
}


-(void)loadView
{
    [super loadView];
    
    //Search Bar
    UISearchBar *sBar = [[UISearchBar alloc]initWithFrame:CGRectZero];;
    [sBar setDelegate:self];
    [sBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:sBar];
    _searchBar = sBar;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[sBar]-(0)-|" options:0 metrics:nil views:@{@"sBar":sBar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-(0)-[sBar]" options:0 metrics:nil views:@{@"topGuide":self.topLayoutGuide, @"sBar":sBar}]];
    
    
    //TableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    [tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:tableView];
    _resultsTableView = tableView;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[tableView]-(0)-|" options:0 metrics:nil views:@{@"tableView":tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sBar]-(0)-[tableView]-(0)-|" options:0 metrics:nil views:@{@"sBar":sBar,@"tableView":tableView}]];
    
    
}


#pragma mark - UISearchBarDelegate

@end
