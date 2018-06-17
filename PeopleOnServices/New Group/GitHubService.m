//
//  GitHubService.m
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import "GitHubService.h"


@implementation GitHubService

- (instancetype)init
{
    self = [super initWithBaseURL:@"https://api.github.com"];
    if (self) {

    }
    return self;
}

- (APIRequestTask<NSArray<User *> *> *)getUsers
{

    APIRequest * request = [[APIRequest alloc] initWithPath:@"/users"];

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

        NSMutableArray<User*> *users = [[NSMutableArray alloc] init];

        if ([json isKindOfClass: [NSArray class]]) {
            NSArray * usersArray = (NSArray*)json;
            for (NSDictionary * usersDic in usersArray) {

                User * user = [[User alloc] init];
                user.uid = [[usersDic objectForKey:@"id"] stringValue];
                user.userName = [usersDic objectForKey:@"login"];
                user.apiSource = [self.baseURL absoluteString];
                user.imageURL = [usersDic objectForKey:@"avatar_url"];
                [users addObject:user];
            }
        }

        [task completion:users error:nil];

    }];

    return task;
}

@end
