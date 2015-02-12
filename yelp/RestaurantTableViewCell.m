//
//  RestaurantTableViewCell.m
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "RestaurantTableViewCell.h"

@implementation RestaurantTableViewCell

- (void)awakeFromNib {
    self.labelName.preferredMaxLayoutWidth = self.labelName.frame.size.width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.labelName.preferredMaxLayoutWidth = self.labelName.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
