//
//  Model.h
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#ifndef Weather_Model_h
#define Weather_Model_h

#import "CityInfo.h"
#import "WeatherInfo.h"

#define URL_IMG @"http://openweathermap.org/img/w/%@.png"
typedef void(^ServiceCompletionBlock)(id result, NSString *errorMessage);

typedef NS_ENUM(NSUInteger, WAParserType) {
    WAParserTypeCity,
    WAParserTypeWeather,
    WAParserTypeSearch
};

typedef NS_ENUM(NSUInteger, WAURLs) {
    WABASE_URL,
    WAURL_7Days,
    WAURL_SEARCH,
    WAURL_SEARCH_BY_ID
};

#endif
