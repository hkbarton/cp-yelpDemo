//
//  FilterTableViewCell.h
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterItem.h"

@class FilterTableViewCell;

@protocol FilterTableViewCellDelegate <NSObject>

-(void)filterTableViewCell:(FilterTableViewCell *)filterTableViewCell didSwitchFilterValueChanged:(FilterItem *)item;

-(void)filterTableViewCell:(FilterTableViewCell *)filterTableViewCell didCheckFilterClicked:(FilterItem *)item withValueChanged:(BOOL)isValueChagned;

@end

@interface FilterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelFilterName;
@property (weak, nonatomic) IBOutlet UISwitch *switchFilterValue;
@property (weak, nonatomic) IBOutlet UIButton *checkFilterValue;
@property (weak, nonatomic) IBOutlet UIImageView *imageExpand;
@property (weak, nonatomic) id<FilterTableViewCellDelegate> delegate;

-(void) setFilterItem: (FilterItem *)item;

@end
