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

- (void)getUsersFromGitHub {
    APIRequest * request = [[APIRequest alloc] initWithPath:@"/users"];

    [[gitHubApi getDataFor:request] completeWithBlock:^(NSData *data, NSError *error) {
        if (error != NULL) {

        }
        NSError * jsonError;
        NSJSONSerialization * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];

        dispatch_async(dispatch_get_main_queue(), ^{

            NSManagedObjectContext * context = [self->_persistentContainer viewContext];

            if ([json isKindOfClass: [NSArray class]]) {
                NSArray * usersArray = (NSArray*)json;
                for (NSDictionary * usersDic in usersArray) {

                    NSString * uid = [[usersDic objectForKey:@"id"] stringValue];

                    User * user = [self getUserById:uid context:context];

                    user.uid = uid;
                    user.userName = [usersDic objectForKey:@"login"];
                    user.apiSource = [self->gitHubApi.baseURL absoluteString];
                    user.imageURL = [usersDic objectForKey:@"avatar_url"];
                }
            }

            NSError *coreDataError = nil;
            if ([context hasChanges] && ![context save:&coreDataError]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                //abort();
            }
        });

    }];
}

- (User* _Nullable) getUserById:(NSString*) uid context:(NSManagedObjectContext*) context {

    NSFetchRequest<User*> * fetch = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    fetch.predicate = [NSPredicate predicateWithFormat:@"uid = %@",uid];
    NSError* error;

    NSArray<User*> * users = [context executeFetchRequest:fetch error:&error];

    if (users.count > 0) {
        return [users firstObject];
    }

    User * user = [[User alloc] initWithContext:context];
    user.uid = uid;

    return user;
}

- (void)getUsersFromDailyMotion {
    APIRequest * request = [[APIRequest alloc] initWithPath:@"/users"];
    request.query = @"fields=avatar_360_url,username,id";
    
    [[dailyMotionApi getDataFor:request] completeWithBlock:^(NSData *data, NSError *error) {

        if (error != NULL) {

        }
        NSError * jsonError;
        NSJSONSerialization * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"dailyMotion data: %@",json.description);

        dispatch_async(dispatch_get_main_queue(), ^{

            NSManagedObjectContext * context = [self->_persistentContainer viewContext];
            if ([json isKindOfClass: [NSDictionary class]]) {
                NSArray * usersArray = [(NSDictionary*)json objectForKey:@"list"];
                for (NSDictionary * usersDic in usersArray) {

                    NSString * uid = [usersDic objectForKey:@"id"];

                    User * user = [self getUserById:uid context:context];

                    user.userName = [usersDic objectForKey:@"username"];
                    user.apiSource = [self->dailyMotionApi.baseURL absoluteString];
                    user.imageURL = [usersDic objectForKey:@"avatar_360_url"];

                }
            }

            NSError *coreDataError = nil;
            if ([context hasChanges] && ![context save:&coreDataError]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                //abort();
            }

        });




    }];

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
