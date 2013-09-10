//
//  CityInfo.h
//  Weather
//
//  Created by Siyana Slavova on 9/9/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeatherInfo;

@interface CityInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * cityID;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet *forecasts;
@end

@interface CityInfo (CoreDataGeneratedAccessors)

- (void)addForecastsObject:(WeatherInfo *)value;
- (void)removeForecastsObject:(WeatherInfo *)value;
- (void)addForecasts:(NSSet *)values;
- (void)removeForecasts:(NSSet *)values;

@end
