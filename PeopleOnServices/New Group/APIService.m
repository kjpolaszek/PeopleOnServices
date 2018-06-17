//
//  APIService.m
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import "APIService.h"

typedef void (^CompletionBlock)(NSObject * _Nullable object,NSError * _Nullable error);

@implementation APIRequestTask {
    CompletionBlock _completionBlock;
    NSObject * _Nullable _object;
    NSError * _Nullable _error;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isCompleted = false;
        _isCanceled = false;
    }
    return self;
}

- (void)completeWithBlock:(void (^)(NSObject * _Nullable, NSError * __nullable))block {
    if (_isCompleted && !_isCanceled) {
        _completionBlock(_object,_error);
    } else {
        _completionBlock = block;
    }
}

-(void) completion:(NSObject * _Nullable) object error:(NSError * _Nullable) error {
    if (_isCompleted || _isCanceled) {
        return;
    }
    _isCompleted = true;
    if (_completionBlock == NULL) {
         _object = object;
        _error = error;
    } else {
        _completionBlock(object,error);
    }
}

- (void)cancel {
    _isCanceled = true;
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


- (APIRequestTask<NSData *> *)getDataFor:(APIRequest *)request {

    NSString * encodedURL = [request.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURLComponents * components = [[NSURLComponents alloc] init];
    components.scheme = _baseURL.scheme;
    components.host = _baseURL.host;
    components.path = encodedURL;
    components.query = request.query;

    NSURL * url = components.URL;

    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];

    APIRequestTask<NSData *> * task = [[APIRequestTask alloc] init];

    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [task completion:data error:error];
    }];

    [dataTask resume];

    return task;
}

- (APIRequestTask<NSArray<User *> *> *)getUsers {
    NSLog(@"This method must be overrided");
    abort();
}

@end
