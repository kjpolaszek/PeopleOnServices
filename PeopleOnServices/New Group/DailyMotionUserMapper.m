//
//  DailyMotionUserMapper.m
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import "DailyMotionUserMapper.h"

@implementation DailyMotionUserMapper {

    NSManagedObjectContext* managedObjectContext;

}

- (instancetype)initWith:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        managedObjectContext = context;
    }
    return self;
}

- (id)mapObject:(NSDictionary *)data {

    User* user = [[User alloc] initWithContext:managedObjectContext];

    return user;
}


@end
