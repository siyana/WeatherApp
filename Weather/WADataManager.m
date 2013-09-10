//
//  WADataManager.m
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WADataManager.h"
#import "WAParserDelegate.h"
#import "WAConnectionService.h"
#import "WAParserInfo.h"

#define BASE_URL @"http://api.openweathermap.org/data/2.5/weather?q="
#define URL_7Days @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=7&mode=json"
#define URL_SEARCH @"http://api.openweathermap.org/data/2.5/find?q=%@&units=metric&mode=json"

@interface WADataManager ()// <WAParserDelegate>//, NSURLConnectionDelegate>

@end

@implementation WADataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (WADataManager *)sharedInstance {
	static dispatch_once_t pred;
	static WADataManager *sharedInstance = nil;
    
	dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
	return sharedInstance;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Weather" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
  //  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
//                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Weather.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Finders

-(void) findCityWithLatitude: (double) latitude andLongitude: (double) longitude
{
    
}

-(void) findCityByName: (NSString *) cityName withURL:  andParser: (WAParserType) parser withCompletion:(ServiceCompletionBlock)completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, cityName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                              timeoutInterval:15.];
    WAConnectionService *service = [[WAConnectionService alloc] initWith:request
                                                          withCompletion:completion
                                                          withParserType:parser];
    [service start];
}

-(void) findWeatherfor7DaysWithLatitude:(double) latitude andLongitude: (double) longitude withCompletion:(ServiceCompletionBlock)completion
{
    //lat=35&lon=139&cnt=7&mode=json
 
   
    //NSString *urlString = [NSString stringWithFormat:@"%@%f&lon=%f%@", URL_7Days, latitude, longitude, URL_JSON];
    NSString *urlString = [NSString stringWithFormat:URL_7Days, latitude, longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                              timeoutInterval:15.];
    WAConnectionService *service = [[WAConnectionService alloc] initWith:request
                                                          withCompletion:completion
                                                          withParserType:WAParserTypeWeather];
    [service start];
}



- (NSFetchedResultsController *)fetchResultsController
{
    if (_fetchResultsController)
        return _fetchResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[CityInfo entityName]];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"dateAdded" ascending:NO];
    fetchRequest.sortDescriptors = @[ sorter ];
    
    NSManagedObjectContext *context = [WADataManager sharedInstance].managedObjectContext;
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil];
    [controller performFetch:nil];
    return controller;
}


@end
