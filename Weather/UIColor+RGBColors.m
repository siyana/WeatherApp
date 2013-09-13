//
//  UIColor+RGBColors.m
//  Weather
//
//  Created by Siyana Slavova on 9/10/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "UIColor+RGBColors.h"

@implementation UIColor (RGBColors)
+(UIColor *)colorWithRedColor:(CGFloat)red greenColor:(CGFloat)green blueColor:(CGFloat)blue alpha:(CGFloat)alpha
{
    UIColor *color = [[UIColor alloc] initWithRed:red/255. green:green/255. blue:blue/255. alpha:alpha];
   
    return color;
}
@end
