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
@end

@implementation WASearchViewController

//-(void)setResults:(NSArray *)results{
//    _results = results;
//    [self.tableView reloadData];
//}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.searchDisplayController.searchBar.delegate = self;
    self.results = [[NSArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
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
    
    // Configure the cell...
    if (self.results){
        cell.textLabel.text = [self.results objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.results objectAtIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Search Delegate methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [[WADataManager sharedInstance] findCityByName:searchBar.text andParser:WAParserTypeSearch withCompletion:^(id result, NSString *errorMessage) {
        if(result && [result isKindOfClass:[NSArray class]]){
            self.results = (NSArray *) result;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    self.results = nil;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SearchCell"];
}

@end
