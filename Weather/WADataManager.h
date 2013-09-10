//
//  WADataManager.h
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface WADataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (WADataManager *)sharedInstance;

-(void) findCityByName: (NSString *) cityName andParser: (WAParserType) parser withCompletion:(ServiceCompletionBlock)completion;
-(void) findWeatherfor7DaysWithLatitude:(double) latitude andLongitude: (double) longitude withCompletion:(ServiceCompletionBlock)completion;

- (NSFetchedResultsController *)fetchResultsController;
@end
