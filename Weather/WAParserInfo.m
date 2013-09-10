//
//  WAParserInfo.m
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WAParserInfo.h"

@implementation WAParserInfo

-(id)initWithJSONDict: (NSDictionary *) jsondict withDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.jsonDict = jsondict;
    }
    return self;
}

- (void)start {
    [self parseDict:self.jsonDict];
}

- (void)parseDict:(NSDictionary *)jsonDict {
    
}

@end
