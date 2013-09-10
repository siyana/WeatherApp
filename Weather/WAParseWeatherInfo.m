//
//  WAParseWeatherInfo.m
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WAParseWeatherInfo.h"

@implementation WAParseWeatherInfo

- (void)parseDict:(NSDictionary *)jsonDict
{
    NSManagedObjectContext *context = [WADataManager sharedInstance].managedObjectContext;
    NSNumber *cityId = [[jsonDict objectForKey:@"city"] objectForKey:@"id"];
    
    if(!cityId){
        if([self.delegate respondsToSelector:@selector(parserDidFail:withErrorMessage:)]){
            NSString *errorMessage = [NSString stringWithFormat:@"Not correct format for json: %@", jsonDict];
            [self.delegate parserDidFail:self withErrorMessage:errorMessage];
            return;
        }
    }
    CityInfo *cityInfo;
    WeatherInfo *weatherInfo;
    
    NSFetchRequest *cityFetchRequest = [[NSFetchRequest alloc] initWithEntityName:[CityInfo entityName]];
    // NSFetchRequest *weatherFetchRequest = [[NSFetchRequest alloc] initWithEntityName:[WeatherInfo entityName]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityID == %d", cityId.integerValue];
    cityFetchRequest.predicate = predicate;
    NSArray *cities = [[WADataManager sharedInstance].managedObjectContext executeFetchRequest:cityFetchRequest error:nil];
    if (cities.count == 0) {
        //cityInfo = [NSEntityDescription insertNewObjectForEntityForName:[CityInfo entityName]
                                                 //inManagedObjectContext:context];
        
    }
    else {
        cityInfo = [cities lastObject];
    }
    
    weatherInfo = [NSEntityDescription insertNewObjectForEntityForName:[WeatherInfo entityName]
                                                inManagedObjectContext:context];
    
    
    NSArray *array = [jsonDict objectForKey:@"list"];
    NSEnumerator *enumerator = [array objectEnumerator];
    NSDictionary *value;
    
    while ((value = (NSDictionary*)[enumerator nextObject])) {
        
        
        
        weatherInfo.date = [NSDate dateWithTimeIntervalSince1970: [[value objectForKey:@"dt"] doubleValue]];
        weatherInfo.windSpeed = [value objectForKey:@"speed"];
        
        
        weatherInfo.weatherIcon = [[[value objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
        weatherInfo.weatherDescription = [[[value objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"];
        weatherInfo.temperature = [[value objectForKey:@"temp"] objectForKey:@"day"];
        //sunset sunrise
        
        weatherInfo.minTemp = [[value objectForKey:@"temp"] objectForKey:@"min"];
        weatherInfo.maxTemp = [[value objectForKey:@"temp"] objectForKey:@"max"];
        
        weatherInfo.humidity  = [value objectForKey:@"humidity"];
        weatherInfo.city = cityInfo;
        
        [[WADataManager sharedInstance] saveContext];
        if ([self.delegate respondsToSelector:@selector(parser:didFinishParsingObject:)]){
            [self.delegate parser:self didFinishParsingObject:weatherInfo];
        }
    }
}

- (void)parseWeatherInfo:(NSDictionary *)weatherDict forCity:(CityInfo *)city
{
     NSManagedObjectContext *context = [WADataManager sharedInstance].managedObjectContext; 
    WeatherInfo *weatherInfo = [NSEntityDescription insertNewObjectForEntityForName:[WeatherInfo entityName]
                                                             inManagedObjectContext:context];
    weatherInfo.date = [NSDate dateWithTimeIntervalSince1970: [[weatherDict objectForKey:@"dt"] doubleValue]];
    weatherInfo.windSpeed = [weatherDict objectForKey:@"speed"];
    
    
    weatherInfo.weatherIcon = [[[weatherDict objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];//?
    weatherInfo.weatherDescription = [[[weatherDict objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"];
    weatherInfo.temperature = [[weatherDict objectForKey:@"main"] objectForKey:@"temp"];
    //sunset sunrise
   // weatherInfo.sunriseTime = [weatherInfo o]
    weatherInfo.minTemp = [[weatherDict objectForKey:@"main"] objectForKey:@"temp_min"];
    weatherInfo.maxTemp = [[weatherDict objectForKey:@"main"] objectForKey:@"temp_max"];
    
    weatherInfo.humidity  = [[weatherDict objectForKey:@"main"] objectForKey:@"humidity"];
    weatherInfo.city = city;
}

@end
