//
//  WAParseWeatherInfo.h
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WAParserInfo.h"

@interface WAParseWeatherInfo : WAParserInfo

- (void)parseWeatherInfo:(NSDictionary *)weatherDict forCity:(CityInfo *)city;

@end
