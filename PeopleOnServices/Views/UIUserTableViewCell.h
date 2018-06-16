//
//  UIUserTableViewCell.h
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *apiLbl;



@end
