//
//  WeatherInfo.h
//  Weather
//
//  Created by Siyana Slavova on 9/13/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CityInfo;

@interface WeatherInfo : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSNumber * maxTemp;
@property (nonatomic, retain) NSNumber * minTemp;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) NSDate * sunriseTime;
@property (nonatomic, retain) NSDate * sunsetTime;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSString * weatherDescription;
@property (nonatomic, retain) NSString * weatherIcon;
@property (nonatomic, retain) NSNumber * windSpeed;
@property (nonatomic, retain) CityInfo *city;
@property (nonatomic, retain) CityInfo *cityDailyForecast;

@end
