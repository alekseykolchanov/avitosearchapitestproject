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
#import "AKImageViewVC.h"

@interface ViewController ()<UISearchBarDelegate,AKResultsDataSourceDelegate,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
{
    __weak UISegmentedControl *_topSegmentedControl;
    __weak UIActivityIndicatorView *_topActivityIndicator;
    
    __weak UISearchBar *_searchBar;
    __weak UITableView *_resultsTableView;
    
    
    __weak UIImageView *_showIconImageView;
    
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
    [[self resultsDataSource]setDelegate:self];
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
                        
                        if (!searchResult || [searchResult count]==0) {
                            UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"Ничего не найдено" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                            [av show];
                        }
                    }
                    
                });
            }
        }];
        
        if ([_itunesSearchApi respondsToSelector:@selector(setFailUpdateBlock:)])
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
                        
                        if (!searchResult || [searchResult count]==0) {
                            UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"Ничего не найдено" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                            [av show];
                        }
                    }
                    
                });
            }
        }];
        
        if ([_gitHubSearchApi respondsToSelector:@selector(setFailUpdateBlock:)])
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

#pragma mark - AKResultsDataSourceDelegate
-(void)resultsDataSource:(AKResultsDataSource *)resultsDataSource didTapOnIconImageView:(UIImageView *)iconImageView
{
    if (!iconImageView || !iconImageView.image)
    {
        _showIconImageView = nil;
        return;
    }
    
    _showIconImageView = iconImageView;
    
    AKImageViewVC *ivc = [AKImageViewVC new];
    [ivc setImage:iconImageView.image];


    [ivc setTransitioningDelegate:self];
    
    [self presentViewController:ivc animated:YES completion:nil];
    
}



#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning <NSObject>

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = [toVC view];
    UIView *fromView = [fromVC view];
    
    CGRect iconRect = [self showIconImageViewWindowFrame];
    CGRect windowBounds = [self windowBounds];
    
    if ([toVC isMemberOfClass:[AKImageViewVC class]]) {
        
        //Stick the toView into position
        toView.frame = [transitionContext finalFrameForViewController:toVC];
        [transitionContext.containerView addSubview:toView];
        
        
        AKImageViewVC *imageVC = (AKImageViewVC*)toVC;
        
        
        [toView setBackgroundColor:[UIColor clearColor]];
        
        if ([transitionContext isAnimated]){
            
            [toView setBackgroundColor:[UIColor clearColor]];
            
            [[imageVC leftIVConstraint]setConstant:iconRect.origin.x];
            [[imageVC rightIVConstraint]setConstant:-windowBounds.size.width + CGRectGetMaxX(iconRect)];
            [[imageVC topIVConstraint]setConstant:iconRect.origin.y];
            [[imageVC bottomIVConstraint]setConstant:-windowBounds.size.height + CGRectGetMaxY(iconRect)];
            [_showIconImageView setHidden:YES];
            
            [imageVC.view layoutIfNeeded];
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                [toView setBackgroundColor:[UIColor blackColor]];
                
                [[imageVC leftIVConstraint]setConstant:0.0f];
                [[imageVC rightIVConstraint]setConstant:0.0f];
                [[imageVC topIVConstraint]setConstant:0.0f];
                [[imageVC bottomIVConstraint]setConstant:0.0f];
                [imageVC.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                if (finished)
                {
                    [transitionContext completeTransition:YES];
                }
            }];
        }else{
            [transitionContext completeTransition:YES];
        }
        
        
    }else if ([fromVC isMemberOfClass:[AKImageViewVC class]]) {
        toView.frame = [transitionContext finalFrameForViewController:toVC];
        [transitionContext.containerView insertSubview:toView belowSubview:fromView];
        
        if ([transitionContext isAnimated]){
            
            AKImageViewVC *imageVC = (AKImageViewVC*)fromVC;
            
            [imageVC.view layoutIfNeeded];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                [fromView setBackgroundColor:[UIColor clearColor]];
 
                [[imageVC leftIVConstraint]setConstant:iconRect.origin.x];
                [[imageVC rightIVConstraint]setConstant:-windowBounds.size.width + CGRectGetMaxX(iconRect)];
                [[imageVC topIVConstraint]setConstant:iconRect.origin.y];
                [[imageVC bottomIVConstraint]setConstant:-windowBounds.size.height + CGRectGetMaxY(iconRect)];
                [imageVC.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                if (finished)
                {
                    [_showIconImageView setHidden:NO];
                    _showIconImageView = nil;
                    [transitionContext completeTransition:YES];
                }
            }];
        }else{
            [_showIconImageView setHidden:NO];
            _showIconImageView = nil;
            [transitionContext completeTransition:YES];
        }
    }
}

-(CGRect)showIconImageViewWindowFrame
{
    if (_showIconImageView){
        UIImageView *iv = _showIconImageView;
        return [iv.superview convertRect:iv.frame toView:self.navigationController.view];
    }else{
        return CGRectMake([self windowBounds].size.width/2.0f - 1.0f, [self windowBounds].size.height/2.0f - 1.0f, 2.0f, 2.0f);
    }
}

-(CGRect)windowBounds{
    return [self navigationController].view.bounds;
}


@end
