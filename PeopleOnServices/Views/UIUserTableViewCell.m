//
//  UIUserTableViewCell.m
//  PeopleOnServices
//
//  Created by Karol Polaszek on 15.06.2018.
//  Copyright © 2018 AISoft. All rights reserved.
//

#import "UIUserTableViewCell.h"


@implementation UIUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAvatarURLString:(NSString *)urlString {

    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
}

@end
