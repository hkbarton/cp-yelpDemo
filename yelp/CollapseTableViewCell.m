//
//  CollapseTableViewCell.m
//  yelp
//
//  Created by Ke Huang on 2/13/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "CollapseTableViewCell.h"

@implementation CollapseTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setIsCollapse:(BOOL)isCollapse {
    _isCollapse = isCollapse;
    if (isCollapse) {
        self.labelCollapseStatus.text = @"Show More";
    } else {
        self.labelCollapseStatus.text = @"Show Less";
    }
}

@end
