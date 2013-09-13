//
//  WASearchViewController.m
//  Weather
//
//  Created by Siyana Slavova on 9/9/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WASearchViewController.h"
#import "WADataManager.h"

@interface WASearchViewController () <UISearchDisplayDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *results;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation WASearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //set up activity indicator
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
    [self.view bringSubviewToFront:self.activityIndicator];
    
    
    self.searchDisplayController.searchBar.delegate = self;
    self.results = [[NSArray alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return 0;
    }
    else
    {
        return [self.results count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (self.results){
        //cell.textLabel.text = [NSString stringWithFormat:@"%@,%@",[[self.results objectAtIndex:indexPath.row] cityName], [[self.results objectAtIndex:indexPath.row] country] ];
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", [[self.results objectAtIndex:indexPath.row] objectForKey:@"cityName"],
                               [[self.results objectAtIndex:indexPath.row] objectForKey:@"country"]];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[WADataManager sharedInstance] deleteCityByName:[[self.results objectAtIndex:indexPath.row] cityName]
//                                               andID:[[self.results objectAtIndex:indexPath.row] cityID]]; // delete all cities without city with this id
//    CityInfo *city = self.results[indexPath.row];
//    [[WADataManager sharedInstance].managedObjectContext rollback];
//    [[WADataManager sharedInstance].managedObjectContext insertObject:city];
    [self isInLoadingMode:YES];
    [[WADataManager sharedInstance] findCityBy:[[self.results objectAtIndex:indexPath.row] objectForKey:@"cityID"] withURL:WAURL_SEARCH_BY_ID andParser:WAParserTypeCity withCompletion:^(id result, NSString *errorMessage) {
        [self isInLoadingMode:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void) isInLoadingMode: (BOOL) loading
{
    if(loading){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        [self.activityIndicator startAnimating];
        
        self.searchDisplayController.searchResultsTableView.alpha = 0.2;
        self.tableView.alpha = 0.2;
        self.searchDisplayController.searchResultsTableView.userInteractionEnabled = NO;
        self.tableView.userInteractionEnabled = NO;
        self.activityIndicator.alpha = 1;
    }
    else{
        [self.activityIndicator stopAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.searchDisplayController.searchResultsTableView.alpha = 1;
        self.tableView.alpha = 1;
        self.searchDisplayController.searchResultsTableView.userInteractionEnabled = YES;
        self.tableView.userInteractionEnabled = YES;
    }
}

#pragma mark - Search Delegate methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self isInLoadingMode: YES];

    [[WADataManager sharedInstance] findCityBy:searchBar.text withURL:WAURL_SEARCH andParser:WAParserTypeSearch withCompletion:^(id result, NSString *errorMessage) {
        if(result && [result isKindOfClass:[NSArray class]]){
            
            self.results = (NSArray *)result;
            [self isInLoadingMode: NO];
            
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //[[WADataManager sharedInstance] deleteCityByName:searchBar.text andID:nil];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    self.results = nil;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SearchCell"];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //[[WADataManager sharedInstance] deleteCityByName:self.searchBar.text andID:nil];
    return YES;
}

@end
