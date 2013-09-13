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

#define BASE_URL @"http://api.openweathermap.org/data/2.5/weather?q=%@&units=metric&mode=json"
#define URL_7Days @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=metric&cnt=10&mode=json"
#define URL_SEARCH @"http://api.openweathermap.org/data/2.5/find?q=%@&units=metric&mode=json"
#define URL_SEARCH_BY_ID @"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&mode=json"

@interface WADataManager ()// <WAParserDelegate>//, NSURLConnectionDelegate>

@end

@implementation WADataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize requestQueue = _requestQueue;

+ (WADataManager *)sharedInstance {
	static dispatch_once_t pred;
	static WADataManager *sharedInstance = nil;
    
	dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
	return sharedInstance;
}

- (NSOperationQueue *)requestQueue
{
    if (_requestQueue)
        return _requestQueue;
    
    _requestQueue = [[NSOperationQueue alloc] init];
    _requestQueue.maxConcurrentOperationCount = 1;
    [_requestQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    
    return _requestQueue;
}

- (void)setRequestQueue:(NSOperationQueue *)requestQueue
{
    _requestQueue = requestQueue;
}

- (void)dealloc
{
    [self.requestQueue removeObserver:self forKeyPath:@"operations"];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

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

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Weather" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

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

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Finders

-(void) findCityWithLatitude: (double) latitude andLongitude: (double) longitude
{
    
}

-(void) findCityBy: (NSString *) citySearchData withURL:(WAURLs) initialURL andParser: (WAParserType) parser withCompletion:(ServiceCompletionBlock)completion
{
    NSString *urlString;
    if(initialURL == WABASE_URL){
        urlString = [NSString stringWithFormat:BASE_URL, citySearchData];
    }else if(initialURL == WAURL_SEARCH){
        urlString = [NSString stringWithFormat:URL_SEARCH, citySearchData];
    }else if(initialURL == WAURL_SEARCH_BY_ID){
        urlString = [NSString stringWithFormat:URL_SEARCH_BY_ID, citySearchData];
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                              timeoutInterval:30.];
    
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

-(void) deleteCityByName: (NSString *) cityName andID: (NSNumber *) cityID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[CityInfo entityName]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName == %@ && cityID != %d", cityName, cityID.integerValue];
    fetchRequest.predicate = predicate;
    NSArray *cities = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for(CityInfo *city in cities){
        [self.managedObjectContext deleteObject:city];
    }
    [self saveContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.requestQueue && [keyPath isEqualToString:@"operations"]) {
        if ([self.requestQueue.operations count] == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishOperations" object:self];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

@end
