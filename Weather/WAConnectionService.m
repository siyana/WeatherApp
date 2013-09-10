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
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
    self.connection = connection;
}

#pragma mark - NSURLConnectionDelegate methods

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [NSMutableData dataWithCapacity:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
    self.responseData = nil;
    self.connection = nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&error];
    
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
        return;
    }
    
    WAParserInfo *parser;
    if (self.parserType == WAParserTypeCity) {
        parser = [[WAParseCityInfo alloc] initWithJSONDict:jsonDict withDelegate:self];
    }
    else if (self.parserType == WAParserTypeWeather) {
        parser = [[WAParseWeatherInfo alloc] initWithJSONDict:jsonDict withDelegate:self];
    }
    else if (self.parserType == WAParserTypeSearch){
        parser = [[WAParserSearchCity alloc] initWithJSONDict:jsonDict withDelegate:self];
        //[self searchCitiesWithJSONDict: jsonDict];
        
    }
    [parser start];
}

//-(void) searchCitiesWithJSONDict: (NSDictionary *) dict
//{
//    NSMutableArray *apps = [[NSMutableArray alloc] init];
//    if(dict){
//        
//        [apps addObject:[dict objectForKey:@"name"]];
//        self.completion(apps, nil);
//    }
//    else{
//        self.completion(nil, @"error in searching");
//    }
//
//}

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
