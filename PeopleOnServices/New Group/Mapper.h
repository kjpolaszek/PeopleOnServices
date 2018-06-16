//
//  Mapper.h
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mapper<ResultObject> : NSObject

- (ResultObject)mapObject:(NSDictionary*) data;

@end
