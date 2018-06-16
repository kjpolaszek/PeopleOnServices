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

@end
