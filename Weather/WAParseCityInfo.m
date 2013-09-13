//
//  WAParseCityInfo.m
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WAParseCityInfo.h"
#import "WAParseWeatherInfo.h"
#import "WAParserInfo.h"

@implementation WAParseCityInfo

- (void)parseDict:(NSDictionary *)jsonDict
{
    //NSLog(@"city json: %@", jsonDict);
    
    NSManagedObjectContext *context = [WADataManager sharedInstance].managedObjectContext;
    
    NSString *cityName = [jsonDict objectForKey:@"name"];
    NSNumber *cityId = [jsonDict objectForKey:@"id"];
    
    if (!cityId || !cityName) {
        if ([self.delegate respondsToSelector:@selector(parserDidFail:withErrorMessage:)]) {
            NSString *errorMessage = [NSString stringWithFormat:@"Not correct format for json: %@", jsonDict];
            [self.delegate parserDidFail:self withErrorMessage:errorMessage];
            return;
        }
    }
    
    CityInfo *cityInfo;
//    WeatherInfo *weatherInfo;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[CityInfo entityName]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityID == %d", cityId.integerValue];
    fetchRequest.predicate = predicate;
    NSArray *cities = [[WADataManager sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if (cities.count == 0) {
         cityInfo = [NSEntityDescription insertNewObjectForEntityForName:[CityInfo entityName]
                                                  inManagedObjectContext:context];
            cityInfo.dateAdded = [NSDate date];
    }
    else {
        cityInfo = [cities lastObject];
    }
    
    cityInfo.cityName = cityName;
    cityInfo.cityID = cityId;
    cityInfo.longitude = [[jsonDict objectForKey:@"coord"] objectForKey:@"lon"];
    cityInfo.latitude = [[jsonDict objectForKey:@"coord"] objectForKey:@"lat"];    
    cityInfo.country = [[jsonDict objectForKey:@"sys"] objectForKey:@"country"];
    
    
    WAParseWeatherInfo *parser = [[WAParseWeatherInfo alloc] init];
    [parser parseWeatherInfo:jsonDict forCity:cityInfo];
    
    [[WADataManager sharedInstance] saveContext];
    
    if ([self.delegate respondsToSelector:@selector(parser:didFinishParsingObject:)])
        [self.delegate parser:self didFinishParsingObject:cityInfo];
}

@end
