//
//  APIService.h
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"
#import "User.h"


@interface APIRequestTask<__covariant ObjectType: NSObject *>: NSObject

@property (nonatomic, readonly) BOOL isCanceled;

@property (nonatomic, readonly) BOOL isCompleted;

-(void) completeWithBlock:(void (^)(ObjectType _Nullable object, NSError* __nullable error)) block;

-(void) completion:(ObjectType _Nullable) object error:(NSError * _Nullable) error;

-(void) cancel;

@end

@interface APIService : NSObject

@property (strong, nonatomic, readonly) NSURL *baseURL;

- (instancetype)initWithBaseURL:(NSString*) baseURL;

- (APIRequestTask<NSData *> *) getDataFor:(APIRequest *) request;

- (APIRequestTask<NSArray<User *> *> *) getUsers;

@end


