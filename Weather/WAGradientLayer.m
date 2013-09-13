//
//  WAGradientLayer.m
//  Weather
//
//  Created by Siyana Slavova on 9/10/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WAGradientLayer.h"
#import "UIColor+RGBColors.h"

@implementation WAGradientLayer

-(WAGradientLayer *) initWithDegrees: (NSNumber *) degrees
{
    self =[super init];
    if(self){
        CAGradientLayer *layer = (CAGradientLayer *)self;
        NSNumber *redTemp;
        NSNumber *greenTemp;
        NSNumber *blueTemp;
               
        NSDictionary *colorsDict = [self colorsWithDegreed:degrees];
       
        redTemp = [colorsDict objectForKey:@"redTemp"];
        greenTemp = [colorsDict objectForKey:@"greenTemp"];
        blueTemp = [colorsDict objectForKey:@"blueTemp"];

        
        UIColor *colorOne = [UIColor colorWithRedColor:[redTemp floatValue] greenColor:[greenTemp floatValue] blueColor:[blueTemp floatValue] alpha:0.8];
        UIColor *colorTwo = [UIColor colorWithRedColor:[redTemp floatValue] greenColor:[greenTemp floatValue] blueColor:[blueTemp floatValue] alpha:0.4];
//        UIColor *colorThree = [UIColor colorWithRedColor:[redTemp floatValue] greenColor:[greenTemp floatValue] blueColor:[blueTemp floatValue] alpha:0.6];
//        UIColor *colorFour = [UIColor colorWithRedColor:[redTemp floatValue] greenColor:[greenTemp floatValue] blueColor:[blueTemp floatValue] alpha:0.5];
//        UIColor *colorFive = [UIColor colorWithRedColor:[redTemp floatValue] greenColor:[greenTemp floatValue] blueColor:[blueTemp floatValue] alpha:0.4];
//        UIColor *colorSix = [UIColor colorWithRedColor:[redTemp floatValue] greenColor:[greenTemp floatValue] blueColor:[blueTemp floatValue] alpha:0.3];
//        UIColor *colorSeven = [UIColor colorWithRedColor:[redTemp floatValue] greenColor:[greenTemp floatValue] blueColor:[blueTemp floatValue] alpha:0.2];
        
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];// colorThree.CGColor, colorFour.CGColor,colorFive.CGColor,colorSix.CGColor,colorSeven.CGColor, nil] ;
        
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
//        NSNumber *stopThree = [NSNumber numberWithFloat:0.30];
//        NSNumber *stopFour = [NSNumber numberWithFloat:0.45];
//        NSNumber *stopFive = [NSNumber numberWithFloat:0.60];
//        NSNumber *stopSix = [NSNumber numberWithFloat:0.75];
//        NSNumber *stopSeven = [NSNumber numberWithFloat:1.0];
        
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];//stopThree, stopFour,stopFive,stopSix,stopSeven, nil];
        
        layer.colors = colors;
        layer.locations = locations;

    }
    return self;
    
}

-(NSDictionary *) colorsWithDegreed: (NSNumber *) degrees
{
    NSNumber *redTemp = [[NSNumber alloc] init];
    NSNumber *greenTemp = [[NSNumber alloc] init];
    NSNumber *blueTemp = [[NSNumber alloc] init];
    if([degrees floatValue] >= -50.0 && [degrees floatValue] <= -40.0){
        redTemp = @25;
        greenTemp = @25;
        blueTemp = @112;
    }
    if([degrees floatValue] > -40.0 && [degrees floatValue] <= -30.0){
        redTemp = @0;
        greenTemp = @0;
        blueTemp = @204;
    }
    if([degrees floatValue] > -30.0 && [degrees floatValue] <= -20.0){
        redTemp = @61;
        greenTemp = @89;
        blueTemp = @171;
    }
    if([degrees floatValue] > -20.0 && [degrees floatValue] <= -10.0){
        redTemp = @58;
        greenTemp = @95;
        blueTemp = @205;
    }
    if([degrees floatValue] > -10.0 && [degrees floatValue] <= 0.0){
        redTemp = @100;
        greenTemp = @149;
        blueTemp = @237;
    }
    
    if([degrees floatValue] > 0 && [degrees floatValue] <= 10.0){
        redTemp = @118;
        greenTemp = @238;
        blueTemp = @198;
    }
    if([degrees floatValue] > 10.0 && [degrees floatValue] <= 20.0){
        redTemp = @255;
        greenTemp = @236;
        blueTemp = @139;
    }
    if([degrees floatValue] > 20.0 && [degrees floatValue] <= 30.0){
        redTemp = @255;
        greenTemp = @215;
        blueTemp = @0;
    }
    if([degrees floatValue] > 30.0 && [degrees floatValue] <= 40.0){
        redTemp = @255;
        greenTemp = @97;
        blueTemp = @3;
    }
    if([degrees floatValue] > 40.0 && [degrees floatValue] <= 50.0){
        redTemp = @255;
        greenTemp = @69;
        blueTemp = @0;
    }
  
    return @{@"redTemp" : redTemp , @"greenTemp" : greenTemp , @"blueTemp" : blueTemp };
            
}

@end
