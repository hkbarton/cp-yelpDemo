//
//  FilterTableViewCell.m
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "FilterTableViewCell.h"

@interface FilterTableViewCell ()

@property (weak, nonatomic) FilterItem *item;

@end

@implementation FilterTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setFilterItem: (FilterItem *)item{
    self.item = item;
    self.labelFilterName.text = item.key;
    self.switchFilterValue.on = item.isSelected;
}

- (IBAction)didSwitchValueChanged:(id)sender {
    self.item.isSelected = self.switchFilterValue.on;
    if (self.delegate) {
        [self.delegate filterTableViewCell:self didFilterValueChanged:self.item];
    }
}

@end
