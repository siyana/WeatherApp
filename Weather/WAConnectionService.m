//
//  WAConnectionService.m
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WAConnectionService.h"
#import "WAParserInfo.h"
#import "WAParseCityInfo.h"
#import "WAParseWeatherInfo.h"
#import "WAParserSearchCity.h"
#import "WADataManager.h"

@interface WAConnectionService () <NSURLConnectionDelegate, WAParserDelegate>

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) ServiceCompletionBlock completion;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, assign) WAParserType parserType;

@end

@implementation WAConnectionService

- (id)initWith:(NSURLRequest *)request
withCompletion:(ServiceCompletionBlock)completion
withParserType:(WAParserType)parserType {
    self = [super init];
    if (self) {
        self.completion = completion;
        self.request = request;
        self.parserType = parserType;
    }
    return self;
}

- (void)start
{
    NSOperationQueue *queue = [[WADataManager sharedInstance] requestQueue];
    NSLog(@"operation count = %d", queue.operationCount);
    
    [NSURLConnection sendAsynchronousRequest:self.request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"error: %@", error.localizedDescription);
                self.completion(nil, error.localizedDescription);
            }
            else {
                NSError* error = nil;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                WAParserInfo *parser;
                if (self.parserType == WAParserTypeCity) {
                    parser = [[WAParseCityInfo alloc] initWithJSONDict:jsonDict withDelegate:self];
                }
                else if (self.parserType == WAParserTypeWeather) {
                    parser = [[WAParseWeatherInfo alloc] initWithJSONDict:jsonDict withDelegate:self];
                }
                else if (self.parserType == WAParserTypeSearch){
                    [self showFoundCitiesFromJSONDict:jsonDict];
                    //parser = [[WAParserSearchCity alloc] initWithJSONDict:jsonDict withDelegate:self];
                }
                
                [parser start];
            }
        });
    }];
}

-(void) showFoundCitiesFromJSONDict: (NSDictionary *) dict
{
    NSMutableArray *cityNames = [[NSMutableArray alloc] init];
    NSArray *array = [dict objectForKey:@"list"];
    NSMutableDictionary *cityInfoDict ;
    NSEnumerator *enumerator = [array objectEnumerator];
    NSDictionary *value = [[NSDictionary alloc] init];
    while ((value = (NSDictionary*)[enumerator nextObject])) {
        cityInfoDict = [[NSMutableDictionary alloc] init];
        [cityInfoDict setObject:[value objectForKey:@"name"] forKey:@"cityName"];
        [cityInfoDict setObject:[value objectForKey:@"id"] forKey:@"cityID"];
        [cityInfoDict setObject:[[value objectForKey:@"sys"] objectForKey:@"country"] forKey:@"country"];
        [cityNames addObject:cityInfoDict];
    }
    
    self.completion(cityNames,nil);
}

#pragma mark - WAParserDelegate methods

- (void)parser:(id)sender didFinishParsingObject:(id)object
{
    self.completion(object, nil);
}

- (void)parserDidFail:(id)sender withErrorMessage:(NSString *)errorMessage
{
    self.completion(nil, errorMessage);
}

@end
