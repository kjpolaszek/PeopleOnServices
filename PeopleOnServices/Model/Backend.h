//
//  Backend.h
//  PeopleOnServices
//
//  Created by Karol Polaszek on 16.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"
#import "PeopleOnServices+CoreDataModel.h"
#import "APIService.h"
@import CoreData;

@protocol BackendDelegate
-(void) fetchingDataDidStart;
-(void) fechingDataDidComplete;
@end

@interface Backend : NSObject

@property (nonatomic, weak) id<BackendDelegate> delegate;

@property (readonly, strong) NSPersistentContainer *persistentContainer;


- (void) updateUsers:(void (^)(void))updateComplete;

- (void) removeAllObjectsByEntityName:(NSString*) name;
- (void) saveContext;

@end
