//
//  WAParserDelegate.h
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WAParserDelegate <NSObject>

-(void) parser: (id) sender didFinishParsingObject: (id) object;
-(void) parserDidFail: (id) sender withErrorMessage:(NSString *)errorMessage;

@end
