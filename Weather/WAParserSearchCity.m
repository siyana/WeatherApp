//
//  WAParserSearchCity.m
//  Weather
//
//  Created by Siyana Slavova on 9/9/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WAParserSearchCity.h"
#import "WAParseWeatherInfo.h"

@implementation WAParserSearchCity
- (void)parseDict:(NSDictionary *)jsonDict
{
    CityInfo *cityInfo;
    NSManagedObjectContext *context = [WADataManager sharedInstance].managedObjectContext;
      NSString *cityName;
    NSNumber *cityId;
    WAParseWeatherInfo *parser = [[WAParseWeatherInfo alloc] init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[CityInfo entityName]];
    NSPredicate *predicate;
    NSArray *cities;    
    NSArray *array = [jsonDict objectForKey:@"list"];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSEnumerator *enumerator = [array objectEnumerator];
    NSDictionary *value;
    while ((value = (NSDictionary*)[enumerator nextObject])) {
        
        cityName = [value objectForKey:@"name"];
        cityId = [value objectForKey:@"id"];
        
        if (!cityId || !cityName) {
            if ([self.delegate respondsToSelector:@selector(parserDidFail:withErrorMessage:)]) {
                NSString *errorMessage = [NSString stringWithFormat:@"Not correct format for json: %@", jsonDict];
                [self.delegate parserDidFail:self withErrorMessage:errorMessage];
                return;
            }
        }
        
        
        
        predicate = [NSPredicate predicateWithFormat:@"cityID == %d", cityId.integerValue];
        fetchRequest.predicate = predicate;
        cities = [[WADataManager sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:nil];
        if (cities.count == 0) {
            cityInfo = [NSEntityDescription insertNewObjectForEntityForName:[CityInfo entityName]
                                                     inManagedObjectContext:context];
        }
        else {
            cityInfo = [cities lastObject];
        }
        
        cityInfo.cityName = cityName;
        cityInfo.cityID = cityId;
        cityInfo.longitude = [[value objectForKey:@"coord"] objectForKey:@"lon"];
        cityInfo.latitude = [[value objectForKey:@"coord"] objectForKey:@"lat"];
        cityInfo.dateAdded = [NSDate date];
        cityInfo.country = [[value objectForKey:@"sys"] objectForKey:@"country"];
        
        
        
        [parser parseWeatherInfo:value forCity:cityInfo];
        [result addObject:cityInfo];

//        [[WADataManager sharedInstance] saveContext];
        
    }
    if ([self.delegate respondsToSelector:@selector(parser:didFinishParsingObject:)]){
        [self.delegate parser:self didFinishParsingObject:result];
    }
}

@end
