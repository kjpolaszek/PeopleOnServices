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
    APIRequest * request = [[APIRequest alloc] initWithPath:@"users"];

    [[gitHubApi getDataFor:request] completeWithBlock:^(NSData *data, NSError *error) {
        if (error != NULL) {

        }
        NSError * jsonError;
        NSJSONSerialization * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];

        NSManagedObjectContext * context = [self->_persistentContainer newBackgroundContext];

        if ([json isKindOfClass: [NSArray class]]) {
            NSArray * usersArray = (NSArray*)json;
            for (NSDictionary * usersDic in usersArray) {
                User * user = [[User alloc] initWithContext:context];
                user.uid = [[usersDic objectForKey:@"id"] stringValue];
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

    }];
}



- (void)getUsersFromDailyMotion {
    APIRequest * request = [[APIRequest alloc] initWithPath:@"users?fields=avatar_360_url,username"];

    [[dailyMotionApi getDataFor:request] completeWithBlock:^(NSData *data, NSError *error) {

        if (error != NULL) {

        }
        NSError * jsonError;
        NSJSONSerialization * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"dailyMotion data: %@",json.description);

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
