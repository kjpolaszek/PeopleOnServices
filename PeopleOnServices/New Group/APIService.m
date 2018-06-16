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

    NSURL * url = [[NSURL alloc] initFileURLWithPath:request.path relativeToURL:_baseURL];

    NSURLRequest * urlRequest = [[NSURLRequest alloc]initWithURL:url];

    APIRequestTask * task = [[APIRequestTask alloc] init];

    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [task completion:data error:error];
    }];

    [dataTask resume];

    return task;
}


@end
