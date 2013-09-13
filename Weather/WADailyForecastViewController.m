//
//  WADailyForecastViewController.m
//  Weather
//
//  Created by Siyana Slavova on 9/11/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WADailyForecastViewController.h"
#import "WeatherInfo.h"
#import "Model.h"
#import "WAWhiteGradientView.h"



#define METERS_PER_MILE 1609.344

@interface WADailyForecastViewController ()

@property (strong, nonatomic) IBOutlet UILabel *cityName;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (strong, nonatomic) IBOutlet UILabel *currentTemp;
@property (strong, nonatomic) IBOutlet UILabel *weatherDesc;
@property (strong, nonatomic) IBOutlet UILabel *minTemp;
@property (strong, nonatomic) IBOutlet UILabel *maxTemp;
@property (strong, nonatomic) IBOutlet UILabel *windSpeed;
@property (strong, nonatomic) IBOutlet UILabel *humidity;
@property (strong, nonatomic) IBOutlet UILabel *pressure;
@property (strong, nonatomic) IBOutlet UILabel *sunset;
@property (strong, nonatomic) IBOutlet UILabel *sunrise;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet WAWhiteGradientView *labelsView;
@property (strong, nonatomic) IBOutlet UIView *littleSubview;


@end

@implementation WADailyForecastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"h:mm a"];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [imgView setImage:[UIImage imageNamed:[self imageForBackground]]];
    self.tableView.backgroundView = imgView;
    
    
    
    [self configureView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureMapWithLatitude: self.detailItem.latitude andLongitude: self.detailItem.longitude];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

-(void)changeLabelsColorWithColor: (UIColor *) color
{
    for( UIView *view in self.labelsView.subviews){
        if([view isKindOfClass:[UILabel class]]){
            UILabel *label = (UILabel *)view;
            label.textColor = color;
        }
    }
    
    for( UIView *view in self.littleSubview.subviews){
        if([view isKindOfClass:[UILabel class]]){
            UILabel *label = (UILabel *)view;
            label.textColor = color;
        }
    }
    
}

- (void)configureView
{
    
    if (self.detailItem) {
        self.navigationItem.title = self.detailItem.cityName;
        self.cityName.text = self.detailItem.cityName;
        WeatherInfo *weather = self.detailItem.dailyForecast;
        self.currentTemp.text =  [NSString stringWithFormat:@"%d℃",  [weather.temperature integerValue]  ];
        
        [self.weatherIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",weather.weatherIcon]]];
        self.weatherDesc.text = weather.weatherDescription;
        self.minTemp.text = [NSString stringWithFormat:@"%d℃",  [weather.minTemp integerValue]  ];
        self.maxTemp.text = [NSString stringWithFormat:@"%d℃",  [weather.maxTemp integerValue]  ];
        self.windSpeed.text = [NSString stringWithFormat:@"%d",  [weather.windSpeed integerValue]  ];
        self.humidity.text = [NSString stringWithFormat:@"%d",  [weather.humidity integerValue]  ];
        self.pressure.text = [NSString stringWithFormat:@"%d",  [weather.pressure integerValue]  ];
        
        self.sunset.text = [self getStringTimeFor:weather.sunsetTime];;
        self.sunrise.text = [self getStringTimeFor:weather.sunriseTime];;
    }
}

-(NSString *) getStringTimeFor: (NSDate *) date
{
    NSString *formattedDate = [self.dateFormatter stringFromDate:date];
    return formattedDate;
}

-(void) configureMapWithLatitude: (NSNumber *) lat andLongitude: (NSNumber *) lon
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = (CLLocationDegrees )[ lat doubleValue];
    coordinate.longitude= (CLLocationDegrees )[ lon doubleValue];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    
    [_mapView setRegion:viewRegion animated:YES];
}


-(NSString *) imageForBackground
{
    NSString *imageName;
    WeatherInfo *weather = self.detailItem.dailyForecast ;
    NSNumber *temperature = weather.temperature ;
    NSString *dayNight = [weather.weatherIcon substringFromIndex:[weather.weatherIcon length] -1];
    //check if its night
    if([dayNight isEqualToString:@"d"]){
        if( [temperature floatValue] >= -50.0 && [temperature floatValue] <= -25.0){
            imageName = @"5025.jpg";
        }
        if( [temperature floatValue] > -25.0 && [temperature floatValue] <= 0.0){
            imageName = @"250.jpg";
        }
        
        if( [temperature floatValue] > 0.0 && [temperature floatValue] <= 10.0){
            imageName = @"010.jpg";
        }
        
        if( [temperature floatValue] >10.0 && [temperature floatValue] <=20.0){
            imageName = @"1020.jpg";
        }
        
        if( [temperature floatValue] >20.0 && [temperature floatValue] <=30.0){
            imageName = @"2030.jpg";
        }
        if( [temperature floatValue] >30.0 && [temperature floatValue] <=50.0){
            imageName = @"3050.jpg";
        }
    }else if ([dayNight isEqualToString:@"n"]){
        imageName = @"night2.jpg";
        
        
    }
    [self changeLabelsColorWithColor:[UIColor whiteColor]];
    
    return imageName;
}

#pragma mark - Table view data source

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

@end
