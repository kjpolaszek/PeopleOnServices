//
//  DetailViewController.h
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleOnServices+CoreDataModel.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) User *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

