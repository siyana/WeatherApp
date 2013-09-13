//
//  WADailyForecastViewController.h
//  Weather
//
//  Created by Siyana Slavova on 9/11/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CityInfo.h"

@interface WADailyForecastViewController : UITableViewController

@property (strong, nonatomic) CityInfo *detailItem;

@end
