//
//  Backend.m
//  PeopleOnServices
//
//  Created by Karol Polaszek on 16.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import "Backend.h"
#import "DailyMotionService.h"
#import "GitHubService.h"
#import "User.h"

@implementation Backend {
    DailyMotionService * dailyMotionApi;
    GitHubService * gitHubApi;
}

@synthesize persistentContainer = _persistentContainer;

- (instancetype)init
{
    self = [super init];
    if (self) {
        dailyMotionApi = [[DailyMotionService alloc] init];
        gitHubApi = [[GitHubService alloc] init];
    }
    return self;
}


- (void)updateUsers:(void (^)(void))updateComplete
{
    __block NSArray<User *> * dailyMotionUsers = nil;

    __block NSArray<User *> * gitHubUsers = nil;

    __block void (^completeBlock)(void) = ^void() {
        if (dailyMotionUsers != NULL && gitHubUsers != NULL) {
            NSMutableArray<User *> *users = [NSMutableArray new];
            [users addObjectsFromArray:dailyMotionUsers];
            [users addObjectsFromArray:gitHubUsers];
            [self saveUsers:users complete:^{
                updateComplete();
            }];
        }
    };

    [[dailyMotionApi getUsers] completeWithBlock:^(NSArray<User *> *object, NSError *error) {
        if (object == nil) {
            dailyMotionUsers = [NSArray new];
        } else {
            dailyMotionUsers = object;
        }
        completeBlock();
    }];

    [[gitHubApi getUsers] completeWithBlock:^(NSArray<User *> *object, NSError *error) {
        if (object == nil) {
            gitHubUsers = [NSArray new];
        } else {
            gitHubUsers = object;
        }
        completeBlock();
    }];

}

- (void)removeAllObjectsByEntityName:(NSString *)name {

    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:name];

    NSError * error;

    NSManagedObjectContext * context = [self.persistentContainer viewContext];

    NSArray *objects = [context executeFetchRequest:request error:&error];

    for (NSManagedObject* object in objects) {
        [context deleteObject:object];
    }

    [self saveContext];

}

- (void) saveUsers:(NSArray<User*>*) users complete:(void (^)(void)) completeBlock; {
    [self->_persistentContainer performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        for (User* user in users) {
            [self updateDataBaseBy:user context:context];
        }

        NSError *coreDataError = nil;
        if ([context hasChanges] && ![context save:&coreDataError]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", coreDataError, coreDataError.userInfo);
            //abort();
        }
        completeBlock();

    }];
}

- (void) updateDataBaseBy:(User*) user context:(NSManagedObjectContext*) context {

    NSFetchRequest<UserEntity*> * fetch = [NSFetchRequest fetchRequestWithEntityName:UserEntity.entity.name];
    fetch.predicate = [NSPredicate predicateWithFormat:@"uid = %@",user.uid];
    NSError* error;

    NSArray<UserEntity*> * users = [context executeFetchRequest:fetch error:&error];

    UserEntity * entity;

    if (users.count > 0) {
        entity = [users firstObject];
    } else {
        entity = [[UserEntity alloc] initWithContext:context];
        entity.uid = user.uid;
    }

    entity.userName = user.userName;
    entity.apiSource = user.apiSource;
    entity.imageURL = user.imageURL;

}

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"PeopleOnServices"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
            [_persistentContainer.viewContext setAutomaticallyMergesChangesFromParent:true];
        }
    }

    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



@end
