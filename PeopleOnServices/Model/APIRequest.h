//
//  NetworkRequest.h
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Mapper.h"

@interface APIRequest : NSObject

@property (strong, nonatomic) NSString *path;

@property (strong, nonatomic) NSString * query;

-(instancetype) initWithPath:(NSString*) path;

@end
