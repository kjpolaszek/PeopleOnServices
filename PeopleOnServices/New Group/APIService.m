//
//  APIService.m
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import "APIService.h"

@implementation APIRequestTask {
    CompletionBlock _Nullable _completionBlock;
    NSData * _Nullable _data;
    NSError * _Nullable _error;
}

-(void) completion:(NSData *) data error:(NSError*) error {
    if (_completionBlock == NULL) {
        _data = data;
        _error = error;
    } else {
        _completionBlock(data,error);
    }
}

-(void) completeWithBlock:(CompletionBlock)completionBlock {
    if (_data != NULL || _error != NULL) {
        completionBlock(_data,_error);
    } else {
        _completionBlock = completionBlock;
    }
}

@end

@implementation APIService {

    NSURLSession * session;

}

- (instancetype)initWithBaseURL:(NSString*) baseURL
{
    self = [super init];
    if (self) {
        _baseURL = [[NSURL alloc] initWithString:baseURL];
        session = [NSURLSession sharedSession];
    }
    return self;
}


- (APIRequestTask *)getDataFor:(APIRequest *)request {

    NSString * encodedURL = [request.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSString * scheme = _baseURL.scheme;
    NSString * host = _baseURL.host;

    NSURLComponents * components = [[NSURLComponents alloc] init];
    components.scheme = _baseURL.scheme;
    components.host = _baseURL.host;
    components.path = encodedURL;
    components.query = request.query;

    NSURL * url = components.URL;

    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];

    APIRequestTask * task = [[APIRequestTask alloc] init];

    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [task completion:data error:error];
    }];

    [dataTask resume];

    return task;
}


@end
