//
//  User.h
//  PeopleOnServices
//
//  Created by Karol Polaszek on 17.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nullable, nonatomic) NSString *apiSource;
@property (nullable, nonatomic) NSString *imageURL;
@property (nullable, nonatomic) NSString *uid;
@property (nullable, nonatomic) NSString *userName;


@end
