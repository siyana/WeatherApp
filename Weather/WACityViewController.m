//
//  WACityViewController.m
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WACityViewController.h"
#import "WADataManager.h"
#import "NSManagedObject+Naming.h"
#import "WACityCell.h"
#import "WAGradientLayer.h"
#import <QuartzCore/QuartzCore.h>
#import "WADailyForecastViewController.h"



@interface WACityViewController () <WACityCellDelegate, UIAlertViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (assign,nonatomic) BOOL isEditing;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) NSIndexPath *edittedIndexPath;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation WACityViewController
{
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    
    [self.backgroundImageView setImage:[UIImage imageNamed:@"day.jpg"]];
    [self.backgroundImageView setAlpha:0.4];
    
    //    [self.backgroundImageView setImage:[UIImage imageNamed:@"night2.jpg"]];
    //    [self.backgroundImageView setAlpha:1];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    //[self.navigationController.navigationBar setAlpha: 0.5];

    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadCities) forControlEvents:UIControlEventValueChanged];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    //    [[WADataManager sharedInstance] findWeatherfor7DaysWithLatitude:43.216671 andLongitude:27.91667 withCompletion:^(id result, NSString *errorMessage) {
    //        NSLog(@"WeatherInfo");
    //    }];
    [self reloadCities];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (!self.fetchResultsController.delegate) {
        self.fetchResultsController.delegate = self;
        BOOL didFetch = [self.fetchResultsController performFetch:nil];
        if (didFetch)
            [self.collectionView reloadData];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedOperationFinishNotification:)
                                                 name:@"didFinishOperations"
                                               object:nil];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.fetchResultsController.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishOperations" object:nil];
}

- (NSFetchedResultsController *)fetchResultsController
{
    if (_fetchResultsController)
        return _fetchResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[CityInfo entityName]];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"dateAdded" ascending:NO];
    fetchRequest.sortDescriptors = @[ sorter ];
    
    NSManagedObjectContext *context = [WADataManager sharedInstance].managedObjectContext;
    _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil];
    [_fetchResultsController performFetch:nil];
    _fetchResultsController.delegate = self;
    
    return _fetchResultsController;
}

#pragma mark - UICollectionView delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    WACityCell *cell = (WACityCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                               forIndexPath:indexPath];
    
    CityInfo *city = [self.fetchResultsController objectAtIndexPath:indexPath];
    cell.cityNameLabel.text = [NSString stringWithFormat:@"%@, %@", city.cityName, city.country];
    WeatherInfo *weather = city.dailyForecast;
    cell.cityDegreesLabel.text =  [NSString stringWithFormat:@"%d℃",  [weather.temperature integerValue]  ];
    

    [cell.weatherIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",weather.weatherIcon]]];
    cell.clipsToBounds = NO;
    
    WAGradientLayer *gradientLayer = [[WAGradientLayer alloc] initWithDegrees: weather.temperature];
    gradientLayer.frame = cell.bounds;
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
    [view.layer addSublayer:gradientLayer];
    cell.backgroundView = view;
    
    //gesture
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    cell.isInEditMode = self.isEditing;
    [self removeGesturesForView:cell];
    [cell addGestureRecognizer:longPressGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self removeGesturesForView:cell.deleteButton];
    [cell.deleteButton addGestureRecognizer:tapGesture];
    
    
    cell.delegate = self;
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.isEditing;
}

- (void)removeGesturesForView:(UIView *)view
{
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        [view removeGestureRecognizer:recognizer];
    }
}

- (IBAction)editButtonTapped:(id)sender {
    self.isEditing = !self.isEditing;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.isEditing){
            self.editButton.title = @"Done";
        }else{
            self.editButton.title = @"Edit";
        }
        
        [self.collectionView reloadData];
    });
}

-(void) handleLongPress: (UILongPressGestureRecognizer *) sender
{
    if(sender.state == UIGestureRecognizerStateBegan && !self.isEditing){
        [self editButtonTapped:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDailyForecast"]) {
        WADailyForecastViewController *dailyForecast = segue.destinationViewController;
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        CityInfo *city = [self.fetchResultsController objectAtIndexPath:indexPath];
        dailyForecast.detailItem = city;
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - WACityCellDelegate method

- (void)deleteButtonTappedForCell:(id)cell
{
    if (!cell)
        return;
    
    self.edittedIndexPath = [self.collectionView indexPathForCell:cell];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete City?"
                                                    message:@"Are you sure you want to delete this city?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate method

- (void)deleteEdittedCity
{
    CityInfo *city = [self.fetchResultsController objectAtIndexPath:self.edittedIndexPath];
    [[WADataManager sharedInstance].managedObjectContext deleteObject:city];
    [[WADataManager sharedInstance] saveContext];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        [self deleteEdittedCity];
    }
    
    self.edittedIndexPath = nil;
}

- (void)reloadCities
{
    if([[self.fetchResultsController fetchedObjects] count] != 0){
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    for(CityInfo *city in [self.fetchResultsController fetchedObjects]) {
        [[WADataManager sharedInstance] findCityBy:[NSString stringWithFormat:@"%@", city.cityID]
                                               withURL:WAURL_SEARCH_BY_ID
                                             andParser:WAParserTypeCity
                                        withCompletion:^(id result, NSString *errorMessage) {
            if (errorMessage) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                
            }
        }];
    }
    }
}

- (void)receivedOperationFinishNotification:(NSNotification *)notification
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.refreshControl endRefreshing];
}

#pragma mark - NSFetchResultsControllerDelegate methods

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @(sectionIndex);
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @(sectionIndex);
            break;
    }
    
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_objectChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([_sectionChanges count] > 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _sectionChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    if ([_objectChanges count] > 0 && [_sectionChanges count] == 0)
    {
        
        if ([self shouldReloadCollectionViewToPreventKnownIssue] || self.collectionView.window == nil) {
            // This is to prevent a bug in UICollectionView from occurring.
            // The bug presents itself when inserting the first object or deleting the last object in a collection view.
            // http://stackoverflow.com/questions/12611292/uicollectionview-assertion-failure
            // This code should be removed once the bug has been fixed, it is tracked in OpenRadar
            // http://openradar.appspot.com/12954582
            [self.collectionView reloadData];
            
        } else {
            
            [self.collectionView performBatchUpdates:^{
                
                for (NSDictionary *change in _objectChanges)
                {
                    [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                        
                        NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                        switch (type)
                        {
                            case NSFetchedResultsChangeInsert:
                                [self.collectionView insertItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeDelete:
                                [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeUpdate:
                                [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeMove:
                                [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                                break;
                        }
                    }];
                }
            } completion:nil];
        }
    }
    
    [_sectionChanges removeAllObjects];
    [_objectChanges removeAllObjects];
}

- (BOOL)shouldReloadCollectionViewToPreventKnownIssue {
    __block BOOL shouldReload = NO;
    for (NSDictionary *change in _objectChanges) {
        [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSFetchedResultsChangeType type = [key unsignedIntegerValue];
            NSIndexPath *indexPath = obj;
            switch (type) {
                case NSFetchedResultsChangeInsert:
                    if ([self.collectionView numberOfItemsInSection:indexPath.section] == 0) {
                        shouldReload = YES;
                    } else {
                        shouldReload = NO;
                    }
                    break;
                case NSFetchedResultsChangeDelete:
                    if ([self.collectionView numberOfItemsInSection:indexPath.section] == 1) {
                        shouldReload = YES;
                    } else {
                        shouldReload = NO;
                    }
                    break;
                case NSFetchedResultsChangeUpdate:
                    shouldReload = NO;
                    break;
                case NSFetchedResultsChangeMove:
                    shouldReload = NO;
                    break;
            }
        }];
    }
    
    return shouldReload;
}

@end
