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

-(void)filterTableViewCell:(FilterTableViewCell *)filterTableViewCell didFilterValueChanged:(FilterItem *)item;

@end

@interface FilterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelFilterName;
@property (weak, nonatomic) IBOutlet UISwitch *switchFilterValue;
@property (weak, nonatomic) id<FilterTableViewCellDelegate> delegate;

-(void) setFilterItem: (FilterItem *)item;

@end
