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

@end
