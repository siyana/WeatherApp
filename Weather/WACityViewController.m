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

@interface WACityViewController ()



@end

@implementation WACityViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[WADataManager sharedInstance] findCityByName:@"London" andParser:WAParserTypeCity withCompletion:^(id result, NSString *errorMessage) {
        [self.collectionView reloadData];
    }];

//    [[WADataManager sharedInstance] findWeatherfor7DaysWithLatitude:43.216671 andLongitude:27.91667 withCompletion:^(id result, NSString *errorMessage) {
//        NSLog(@"WeatherInfo");
//    }];
}

#pragma mark - UICollectionView delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[WADataManager sharedInstance].fetchResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [WADataManager sharedInstance].fetchResultsController.sections.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    WACityCell *cell = (WACityCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                               forIndexPath:indexPath];
    
    CityInfo *city = [[WADataManager sharedInstance].fetchResultsController objectAtIndexPath:indexPath];
    cell.cityNameLabel.text = city.cityName;
    WeatherInfo *weather = [[city.forecasts allObjects] lastObject];
    cell.cityDegreesLabel.text = weather.temperature.description;
    //cell.cityDegreesLabel.text
        
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
