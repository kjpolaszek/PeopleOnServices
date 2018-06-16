//
//  DailyMotionUserMapper.h
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import "Mapper.h"
#import "PeopleOnServices+CoreDataModel.h"

@interface DailyMotionUserMapper : Mapper<User*>

-(instancetype)initWith:(NSManagedObjectContext*) context;

@end
