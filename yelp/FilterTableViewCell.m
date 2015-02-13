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
    self.switchFilterValue.hidden = YES;
    self.checkFilterValue.hidden = YES;
    [self.checkFilterValue setImage:[UIImage imageNamed:@"UnCheck"] forState:UIControlStateNormal];
    [self.checkFilterValue setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setFilterItem: (FilterItem *)item{
    self.item = item;
    self.labelFilterName.text = item.key;
    if (item.filterType == 1 || item.filterType == 2) {
        self.switchFilterValue.hidden = YES;
        self.checkFilterValue.hidden = NO;
        self.checkFilterValue.selected = item.isSelected;
    } else {
        self.switchFilterValue.hidden = NO;
        self.checkFilterValue.hidden = YES;
        self.switchFilterValue.on = item.isSelected;
    }
}

- (IBAction)didSwitchValueChanged:(id)sender {
    self.item.isSelected = self.switchFilterValue.on;
    if (self.delegate) {
        [self.delegate filterTableViewCell:self didSwitchFilterValueChanged:self.item];
    }
}

- (IBAction)onCheckFilterValueClick:(id)sender {
    BOOL isValueChanged = NO;
    if (!self.checkFilterValue.selected) {
        self.checkFilterValue.selected = YES;
        self.item.isSelected = YES;
        isValueChanged = YES;
    }
    if (self.delegate) {
        [self.delegate filterTableViewCell:self didCheckFilterClicked:self.item withValueChanged:isValueChanged];
    }
}


@end
