//
//  NSManagedObject+Naming.m
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "NSManagedObject+Naming.h"

@implementation NSManagedObject (Naming)

+ (NSString *)entityName {
    return [[self class] description];
}

@end
