//
//  WAParserInfo.h
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAParserDelegate.h"
#import "WADataManager.h"
#import "NSManagedObject+Naming.h"

@interface WAParserInfo : NSObject

@property (nonatomic, weak) id <WAParserDelegate> delegate;
@property (nonatomic, strong) NSDictionary *jsonDict;

- (id)initWithJSONDict: (NSDictionary *) jsondict withDelegate:(id)delegate;
- (void)start;
- (void)parseDict:(NSDictionary *)jsonDict;

@end
