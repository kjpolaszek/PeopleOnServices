//
//  DailyMotionService.m
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import "DailyMotionService.h"

@implementation DailyMotionService

- (instancetype)init
{
    self = [super initWithBaseURL:@"https://api.dailymotion.com"];
    if (self) {
    }
    return self;
}

- (APIRequestTask<NSArray<User *> *> *)getUsers
{
    
    APIRequest * request = [[APIRequest alloc] initWithPath:@"/users"];
    request.query = @"fields=avatar_360_url,username,id";

    APIRequestTask<NSArray<User *> *> * task = [[APIRequestTask<NSArray<User *> *> alloc] init];

    [[self getDataFor:request] completeWithBlock:^(NSData *object, NSError *error) {
        
        if (error != NULL) {
            [task completion:nil error:error];
            return;
        }
        
        if (task.isCanceled) {
            return;
        }
        
        NSError * jsonError;
        NSJSONSerialization * json = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (jsonError != NULL) {
            [task completion:nil error:error];
        }
        
        if (task.isCanceled) {
            return;
        }
        
        NSMutableArray<User*> * users = [[NSMutableArray alloc] init];
        
        if ([json isKindOfClass: [NSDictionary class]]) {
            NSArray * usersArray = [(NSDictionary*)json objectForKey:@"list"];
            for (NSDictionary * usersDic in usersArray) {
                
                User * user = [[User alloc] init];
                user.uid = [usersDic objectForKey:@"id"];
                user.userName = [usersDic objectForKey:@"username"];
                user.apiSource = [self.baseURL absoluteString];
                user.imageURL = [usersDic objectForKey:@"avatar_360_url"];
                [users addObject:user];
            }
        }
        
        [task completion:users error:nil];
    }];

    return task;
}

@end
