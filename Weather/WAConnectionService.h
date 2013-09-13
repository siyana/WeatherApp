//
//  WAConnectionService.h
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface WAConnectionService : NSObject


- (id)initWith:(NSURLRequest *)request
withCompletion:(ServiceCompletionBlock)completion
withParserType:(WAParserType)parserType;
- (void)start;

@end
