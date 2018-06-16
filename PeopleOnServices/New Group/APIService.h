//
//  APIService.h
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"

typedef void (^CompletionBlock)(NSData* data,NSError* error);

@interface APIRequestTask: NSObject

-(void) completeWithBlock:(CompletionBlock)completionBlock;

@end

@interface APIService : NSObject

@property (strong, nonatomic, readonly) NSURL *baseURL;

- (instancetype)initWithBaseURL:(NSString*) baseURL;

- (APIRequestTask*) getDataFor:(APIRequest *) request;


@end


