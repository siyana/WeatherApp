//
//  WAWhiteGradientView.m
//  Weather
//
//  Created by Siyana Slavova on 9/13/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WAWhiteGradientView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WAWhiteGradientView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        CAGradientLayer *layer = (CAGradientLayer *)self.layer;
        
        UIColor *colorOne = [UIColor colorWithWhite:0 alpha:0.1];
        UIColor *colorTwo = [UIColor colorWithWhite:0 alpha:0.3];
        UIColor *colorThree = [UIColor colorWithWhite:0 alpha:0.4];
        UIColor *colorFour = [UIColor colorWithWhite:0 alpha:0.5];
        UIColor *colorFive = [UIColor colorWithWhite:0 alpha:0.4];
        UIColor *colorSix = [UIColor colorWithWhite:0 alpha:0.2];
        UIColor *colorSeven = [UIColor colorWithWhite:0 alpha:0.1];
        
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor,colorFive.CGColor,colorSix.CGColor,colorSeven.CGColor, nil] ;
        
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        NSNumber *stopTwo = [NSNumber numberWithFloat:0.15];
        NSNumber *stopThree = [NSNumber numberWithFloat:0.30];
        NSNumber *stopFour = [NSNumber numberWithFloat:0.45];
        NSNumber *stopFive = [NSNumber numberWithFloat:0.60];
        NSNumber *stopSix = [NSNumber numberWithFloat:0.75];
        NSNumber *stopSeven = [NSNumber numberWithFloat:1.0];
        
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour,stopFive,stopSix,stopSeven, nil];
        
        layer.colors = colors;
        layer.locations = locations;
    }
    return self;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end
